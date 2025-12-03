#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Updates the vitals. Called from the statemachine's onState functions.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Update Ran (at least 1 second between runs) <BOOL>
 *
 * Example:
 * [player] call ace_medical_vitals_fnc_handleUnitVitals
 *
 * Public: No
 */

params ["_patient"];

private _lastTimeUpdated = _patient getVariable [QACEGVAR(medical_vitals,lastTimeUpdated), 0];
private _deltaT = (CBA_missionTime - _lastTimeUpdated) min 10;
if (_deltaT < 1) exitWith { false }; // state machines could be calling this very rapidly depending on number of local units

if (_deltaT > 7) then {
    WARNING_1("VITALS TIME BETWEEN SYNC IS LONG (%1s)",_deltaT);
};

BEGIN_COUNTER(Vitals);

_patient setVariable [QACEGVAR(medical_vitals,lastTimeUpdated), CBA_missionTime];
private _lastTimeValuesSynced = _patient getVariable [QACEGVAR(medical_vitals,lastMomentValuesSynced), 0];
private _syncValues = (CBA_missionTime - _lastTimeValuesSynced) >= (10 + floor(random 10));

if (_syncValues) then {
    _patient setVariable [QACEGVAR(medical_vitals,lastMomentValuesSynced), CBA_missionTime];
};

private _bloodVolume = ([_patient, _deltaT, _syncValues] call ACEFUNC(medical_status,getBloodVolumeChange));
_bloodVolume = 0 max _bloodVolume min DEFAULT_BLOOD_VOLUME;

// @todo: replace this and the rest of the setVariable with EFUNC(common,setApproximateVariablePublic)
_patient setVariable [VAR_BLOOD_VOL, _bloodVolume, _syncValues];

// Set variables for synchronizing information across the net
private _hemorrhage = switch (true) do {
    case (_bloodVolume < BLOOD_VOLUME_CLASS_4_HEMORRHAGE): { 4 };
    case (_bloodVolume < BLOOD_VOLUME_CLASS_3_HEMORRHAGE): { 3 };
    case (_bloodVolume < BLOOD_VOLUME_CLASS_2_HEMORRHAGE): { 2 };
    case (_bloodVolume < (BLOOD_VOLUME_CLASS_1_HEMORRHAGE - 0.05)): { 1 };
    default {0};
};

if (_hemorrhage != GET_HEMORRHAGE(_patient)) then {
    _patient setVariable [VAR_HEMORRHAGE, _hemorrhage, true];
};

private _woundBloodLoss = GET_WOUND_BLEEDING(_patient);

private _inPain = GET_PAIN_PERCEIVED(_patient) > 0;
if (_inPain isNotEqualTo IS_IN_PAIN(_patient)) then {
    _patient setVariable [VAR_IN_PAIN, _inPain, true];
};

// Handle pain from tourniquets, that have been applied more than 120 s ago
private _tourniquetPain = 0;
private _tourniquets = _patient getVariable [QEGVAR(disability,Tourniquet_ApplyTime), [-1,-1,-1,-1,-1,-1]];
{
    if (_x != -1 && {CBA_missionTime - _x > 120}) then {
        _tourniquetPain = _tourniquetPain max (CBA_missionTime - _x - 120) * 0.001;
    };
} forEach _tourniquets;
if (_tourniquetPain > 0) then {
    [_patient, _tourniquetPain] call ACEFUNC(medical_status,adjustPainLevel);
};

// Get Medication Adjustments:
private _hrTargetAdjustment = 0;
private _painSuppressAdjustment = 0;
private _peripheralResistanceAdjustment = 0;
private _respirationRateAdjustment = 0;
private _coSensitivityAdjustment = 0;
private _breathingEffectivenessAdjustment = 0;

if (count (_patient getVariable [QEGVAR(circulation,ActiveMedication), []]) > 0) then {
    {
        private _medication = _x;

        /*if (typeName (MEDICATION_VITALS_FUNCTION(_forEachIndex)) isNotEqualTo "CODE") then {
            continue;
        };*/

        private _medicationMinimumConcentration = EGVAR(circulation,MedicationList_MinimumThreshold) select _forEachIndex;

        private _medicationConcentration = [_patient, _medication] call EFUNC(circulation,getMedicationConcentration);

        if (_medicationConcentration < _medicationMinimumConcentration) then {
            continue;
        };

        private _medicationEffects = [_patient, _medicationMinimumConcentration] call MEDICATION_VITALS_FUNCTION(_forEachIndex);

        _medicationEffects params [["_entryPainSuppressAdjustment", 0], ["_entryHRTargetAdjustment", 0], ["_entryPeripheralResistanceAdjustment", 0], ["_entryRespirationRateAdjustment", 0], ["_entryCOSensitivityAdjustment", 0], ["_entryBreathingEffectivenessAdjustment", 0]];

        _painSuppressAdjustment = _painSuppressAdjustment + _entryPainSuppressAdjustment;
        _hrTargetAdjustment = _hrTargetAdjustment + _entryHRTargetAdjustment;
        _peripheralResistanceAdjustment = _peripheralResistanceAdjustment + _entryPeripheralResistanceAdjustment;
        _respirationRateAdjustment = _respirationRateAdjustment + _entryRespirationRateAdjustment;
        _coSensitivityAdjustment = _coSensitivityAdjustment + _entryCOSensitivityAdjustment;
        _breathingEffectivenessAdjustment = _breathingEffectivenessAdjustment + _entryBreathingEffectivenessAdjustment;
    } forEach EGVAR(circulation,MedicationList);
};

private _reactionSeverity = _patient getVariable [QEGVAR(circulation,HemolyticReaction_Severity), 0];

if (_reactionSeverity > 0) then {
    _hrTargetAdjustment = _hrTargetAdjustment + (_reactionSeverity * 15);
    _respirationRateAdjustment = _respirationRateAdjustment - _reactionSeverity * 5;
    _peripheralResistanceAdjustment = _peripheralResistanceAdjustment - _reactionSeverity * 15;
    _breathingEffectivenessAdjustment = _breathingEffectivenessAdjustment - (_reactionSeverity * 0.05);
};

// Update SPO2 intake and usage since last update
private _oxygenSaturation = [_patient, _respirationRateAdjustment, _coSensitivityAdjustment, _breathingEffectivenessAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updateOxygen);

if (_oxygenSaturation < ACM_OXYGEN_HYPOXIA) then { // Severe hypoxia causes heart to give out
    _hrTargetAdjustment = _hrTargetAdjustment - 10 * abs (ACM_OXYGEN_HYPOXIA - _oxygenSaturation);
};

if ((_patient getVariable [QEGVAR(breathing,TensionPneumothorax_State), false]) || (_patient getVariable [QEGVAR(breathing,Hardcore_Pneumothorax), false])) then {
    _hrTargetAdjustment = _hrTargetAdjustment - ([25,35] select (_patient getVariable [QEGVAR(breathing,TensionPneumothorax_State), false]));
} else {
    if (_patient getVariable [QEGVAR(breathing,Pneumothorax_State), 0] > 0) then {
        _hrTargetAdjustment = _hrTargetAdjustment - (5 * (_patient getVariable [QEGVAR(breathing,Pneumothorax_State), 0]));
    };
};

if ((_patient getVariable [QEGVAR(circulation,TransfusedBlood_Volume), 0]) > 0.05) then {
    _hrTargetAdjustment = _hrTargetAdjustment - ((_patient getVariable [QEGVAR(circulation,TransfusedBlood_Volume), 0]) / 0.05);
};

if (EGVAR(CBRN,enable)) then {
    _hrTargetAdjustment = _hrTargetAdjustment - (linearConversion [15, 100, (_patient getVariable [QGVAR_BUILDUP(Chemical_Sarin), 0]), 0, 35, true]) - (linearConversion [15, 100, (_patient getVariable [QGVAR_BUILDUP(Chemical_Lewisite), 0]), 0, 35, true]);
};

private _heartRate = [_patient, _hrTargetAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updateHeartRate);
[_patient, _painSuppressAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updatePainSuppress);

private _vasoconstriction = GET_VASOCONSTRICTION(_patient);
private _targetVasoconstriction = 0;

if (_bloodVolume < 5.9) then {
    _targetVasoconstriction = linearConversion [5.9, 4.5, _bloodVolume, 0, 50, true];
};

if (_bloodVolume > 4) then {
    private _MAPAdjustment = 0;
    private _MAP = GET_MAP_PATIENT(_patient);

    if (_MAP > 94) then {
        _MAPAdjustment = linearConversion [94, 120, _MAP, 0, -70, true];
    } else {
        if (_MAP < 88) then {
            _MAPAdjustment = linearConversion [88, 60, _MAP, 0, 40, true];
        };
    };

    _targetVasoconstriction = (_targetVasoconstriction + _MAPAdjustment) min 50;

    if (IS_BLEEDING(_patient) && _targetVasoconstriction < 0) then {
        _targetVasoconstriction = _targetVasoconstriction * 0.75;
    };
};

private _vasoconstrictionChange = (_targetVasoconstriction - _vasoconstriction) / 4;

if (_targetVasoconstriction > _vasoconstriction) then {
    _vasoconstriction = (_vasoconstriction + _vasoconstrictionChange * (_deltaT min 1.2)) min _targetVasoconstriction;
} else {
    _vasoconstriction = (_vasoconstriction + _vasoconstrictionChange * (_deltaT min 1.2)) max _targetVasoconstriction;
};

_patient setVariable [QEGVAR(circulation,Vasoconstriction_State), _vasoconstriction, _syncValues];

_peripheralResistanceAdjustment = _peripheralResistanceAdjustment + _vasoconstriction;

[_patient, _peripheralResistanceAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updatePeripheralResistance);

private _bloodPressure = [_patient] call ACEFUNC(medical_status,getBloodPressure);
_patient setVariable [VAR_BLOOD_PRESS, _bloodPressure, _syncValues];

_bloodPressure params ["_BPDiastolic", "_BPSystolic"];

private _respirationRate = GET_RESPIRATION_RATE(_patient);

private _activeGracePeriod = IN_CRITICAL_STATE(_patient);

// Statements are ordered by most lethal first.
switch (true) do {
    case (_bloodVolume < BLOOD_VOLUME_FATAL): {
        TRACE_3("BloodVolume Fatal",_patient,BLOOD_VOLUME_FATAL,_bloodVolume);
        [QACEGVAR(medical,Bleedout), _patient] call CBA_fnc_localEvent;
    };
    case (_oxygenSaturation < ACM_OXYGEN_DEATH): {
        if (ACM_OXYGEN_DEATH - (random 5) > _oxygenSaturation) then {
            [_patient, "Oxygen Deprivation"] call ACEFUNC(medical_status,setDead);
        };
    };
    case (IN_CRDC_ARRST(_patient)): {}; // if in cardiac arrest just break now to avoid throwing unneeded events
    case ([_patient] call EFUNC(circulation,recentAEDShock)): {};
    case (_hemorrhage == 4): {
        TRACE_3("Class IV Hemorrhage",_patient,_hemorrhage,_bloodVolume);
        [QACEGVAR(medical,FatalVitals), _patient] call CBA_fnc_localEvent;
        [_patient] call EFUNC(circulation,updateCirculationState);
    };
    case ((_patient getVariable [QEGVAR(circulation,ROSC_Time), 0]) + 10 > CBA_missionTime): {};
    case (_oxygenSaturation < ACM_OXYGEN_HYPOXIA): {
        private _nextCheck = _patient getVariable [QEGVAR(circulation,ReversibleCardiacArrest_HypoxiaTime), CBA_missionTime];
        private _enterCardiacArrest = false;
        if (CBA_missionTime >= _nextCheck) then {
            _enterCardiacArrest = (ACM_OXYGEN_HYPOXIA - (random 10) > _oxygenSaturation);
            _patient setVariable [QEGVAR(circulation,ReversibleCardiacArrest_HypoxiaTime), CBA_missionTime + 5];
            [_patient] call EFUNC(circulation,updateCirculationState);
        };
        if (_enterCardiacArrest) then {
            [QACEGVAR(medical,FatalVitals), _patient] call CBA_fnc_localEvent;
        } else {
            [QACEGVAR(medical,CriticalVitals), _patient] call CBA_fnc_localEvent;
        };
    };
    case (!_activeGracePeriod && {_heartRate < 40 || {_heartRate > 220}}): {
        TRACE_2("heartRate Fatal",_patient,_heartRate);
        if (_heartRate > 220) then {
            _patient setVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_VT, true];
            _patient setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_PVT];
        } else {
            if (([_patient, "Adenosine", [ACM_ROUTE_IV]] call EFUNC(circulation,getMedicationConcentration)) > 0.5) then {
                _patient setVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_Asystole, true];
                _patient setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_Asystole];
            } else {
                _patient setVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_VF, true];
                _patient setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_VF];
            };
        };
        [QGVAR(handleFatalVitals), _patient] call CBA_fnc_localEvent;
    };
    case (GET_MAP(_BPSystolic,_BPDiastolic) < 55): {
        [QGVAR(handleFatalVitals), _patient] call CBA_fnc_localEvent;
    };
    case (GET_MAP(_BPSystolic,_BPDiastolic) > 200): {
        [QGVAR(handleFatalVitals), _patient] call CBA_fnc_localEvent;
    };
    case (IS_UNCONSCIOUS(_patient)): {}; // Already unconscious
    case (_woundBloodLoss > BLOOD_LOSS_KNOCK_OUT_THRESHOLD): {
        [QACEGVAR(medical,CriticalVitals), _patient] call CBA_fnc_localEvent;
    };
    case (_oxygenSaturation < ACM_OXYGEN_UNCONSCIOUS): {
        if (ACM_OXYGEN_UNCONSCIOUS - (random 10) > _oxygenSaturation) then {
            [QACEGVAR(medical,CriticalVitals), _patient] call CBA_fnc_localEvent;
        };
    };
    case (_respirationRate < 6): {
        [QACEGVAR(medical,CriticalVitals), _patient] call CBA_fnc_localEvent;
    };
    case (_woundBloodLoss > 0): {
        [QACEGVAR(medical,LoweredVitals), _patient] call CBA_fnc_localEvent;
    };
    case (_inPain): {
        [QACEGVAR(medical,LoweredVitals), _patient] call CBA_fnc_localEvent;
    };
};

#ifdef DEBUG_MODE_FULL
private _cardiacOutput = [_patient] call ACEFUNC(medical_status,getCardiacOutput);
if (!isPlayer _patient) then {
    private _painLevel = _patient getVariable [VAR_PAIN, 0];
    hintSilent format["blood volume: %1, blood loss: [%2, %3]\nhr: %4, bp: %5, pain: %6", round(_bloodVolume * 100) / 100, round(_woundBloodLoss * 1000) / 1000, round((_woundBloodLoss / (0.001 max _cardiacOutput)) * 100) / 100, round(_heartRate), _bloodPressure, round(_painLevel * 100) / 100];
};
#endif

END_COUNTER(Vitals);

//placed outside the counter as 3rd-party code may be called from this event
[QACEGVAR(medical,handleUnitVitals), [_patient, _deltaT]] call CBA_fnc_localEvent;

true
