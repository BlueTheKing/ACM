#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Updates the vitals. Called from the statemachine's onState functions.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * Return Value:
 * Update Ran (at least 1 second between runs) <BOOL>
 *
 * Example:
 * [player] call ace_medical_vitals_fnc_handleUnitVitals
 *
 * Public: No
 */

params ["_unit"];

private _lastTimeUpdated = _unit getVariable [QACEGVAR(medical_vitals,lastTimeUpdated), 0];
private _deltaT = (CBA_missionTime - _lastTimeUpdated) min 10;
if (_deltaT < 1) exitWith { false }; // state machines could be calling this very rapidly depending on number of local units

if (_deltaT > 7) then {
    WARNING_1("VITALS TIME BETWEEN SYNC IS LONG (%1s)",_deltaT);
};

BEGIN_COUNTER(Vitals);

_unit setVariable [QACEGVAR(medical_vitals,lastTimeUpdated), CBA_missionTime];
private _lastTimeValuesSynced = _unit getVariable [QACEGVAR(medical_vitals,lastMomentValuesSynced), 0];
private _syncValues = (CBA_missionTime - _lastTimeValuesSynced) >= (10 + floor(random 10));

if (_syncValues) then {
    _unit setVariable [QACEGVAR(medical_vitals,lastMomentValuesSynced), CBA_missionTime];
};

private _bloodVolume = ([_unit, _deltaT, _syncValues] call ACEFUNC(medical_status,getBloodVolumeChange));
_bloodVolume = 0 max _bloodVolume min DEFAULT_BLOOD_VOLUME;

// @todo: replace this and the rest of the setVariable with EFUNC(common,setApproximateVariablePublic)
_unit setVariable [VAR_BLOOD_VOL, _bloodVolume, _syncValues];

// Set variables for synchronizing information across the net
private _hemorrhage = switch (true) do {
    case (_bloodVolume < BLOOD_VOLUME_CLASS_4_HEMORRHAGE): { 4 };
    case (_bloodVolume < BLOOD_VOLUME_CLASS_3_HEMORRHAGE): { 3 };
    case (_bloodVolume < BLOOD_VOLUME_CLASS_2_HEMORRHAGE): { 2 };
    case (_bloodVolume < (BLOOD_VOLUME_CLASS_1_HEMORRHAGE - 0.05)): { 1 };
    default {0};
};

if (_hemorrhage != GET_HEMORRHAGE(_unit)) then {
    _unit setVariable [VAR_HEMORRHAGE, _hemorrhage, true];
};

private _woundBloodLoss = GET_WOUND_BLEEDING(_unit);

private _inPain = GET_PAIN_PERCEIVED(_unit) > 0;
if (_inPain isNotEqualTo IS_IN_PAIN(_unit)) then {
    _unit setVariable [VAR_IN_PAIN, _inPain, true];
};

// Handle pain from tourniquets, that have been applied more than 120 s ago
private _tourniquetPain = 0;
private _tourniquets = _unit getVariable [QEGVAR(disability,Tourniquet_ApplyTime), [-1,-1,-1,-1,-1,-1]];
{
    if (_x != -1 && {CBA_missionTime - _x > 120}) then {
        _tourniquetPain = _tourniquetPain max (CBA_missionTime - _x - 120) * 0.001;
    };
} forEach _tourniquets;
if (_tourniquetPain > 0) then {
    [_unit, _tourniquetPain] call ACEFUNC(medical_status,adjustPainLevel);
};

// Get Medication Adjustments:
private _hrTargetAdjustment = 0;
private _painSuppressAdjustment = 0;
private _peripheralResistanceAdjustment = 0;
private _respirationRateAdjustment = 0;
private _coSensitivityAdjustment = 0;
private _breathingEffectivenessAdjustment = 0;
private _adjustments = _unit getVariable [VAR_MEDICATIONS,[]];

private _HRAdjustmentMap = +GVAR(MedicationTypes_MaxHRAdjust);
private _RRAdjustmentMap = +GVAR(MedicationTypes_MaxRRAdjust);
private _painSuppressAdjustmentMap = +GVAR(MedicationTypes_MaxPainAdjust);

if (_adjustments isNotEqualTo []) then {
    private _deleted = false;
    {
        _x params ["_medication", "_timeAdded", "_timeTillMaxEffect", "_maxTimeInSystem", "_hrAdjust", "_painAdjust", "_flowAdjust", "_administrationType", "_maxEffectTime", "_rrAdjust", "_coSensitivityAdjust", "_breathingEffectivenessAdjust", "_concentration", "_medicationType"];
        private _timeInSystem = CBA_missionTime - _timeAdded;
        if (_timeInSystem >= _maxTimeInSystem) then {
            _deleted = true;
            _adjustments deleteAt _forEachIndex;
        } else {
            private _effectRatio = [_administrationType, _timeInSystem, _timeTillMaxEffect, _maxTimeInSystem, _maxEffectTime] call EFUNC(circulation,getMedicationEffect);
            if (_hrAdjust != 0 && (GET_HEART_RATE(_unit) > 0)) then {
                private _HREffect = [(GET_HEART_RATE(_unit) / (ACM_TARGETVITALS_HR(_unit) - 20)), ((ACM_TARGETVITALS_HR(_unit) + 20) / GET_HEART_RATE(_unit))] select (_hrAdjust > 0);

                if (_medicationType in _HRAdjustmentMap) then {
                    (_HRAdjustmentMap get _medicationType) params ["_medHRIncrease", "_medMaxHRIncrease"];

                    private _newHRIncrease = _medHRIncrease + _hrAdjust * _effectRatio * _HREffect;
                    private _positive = _medMaxHRIncrease > 0;

                    if ([(_medHRIncrease > (_newHRIncrease max _medMaxHRIncrease)), (_medHRIncrease < (_newHRIncrease min _medMaxHRIncrease))] select _positive) then {
                        private _cappedHRIncrease = [(_newHRIncrease max _medMaxHRIncrease), (_newHRIncrease min _medMaxHRIncrease)] select _positive;
                        _HRAdjustmentMap set [_medicationType, [_cappedHRIncrease, _medMaxHRIncrease]];
                    };
                } else {
                    _hrTargetAdjustment = _hrTargetAdjustment + _hrAdjust * _effectRatio * _HREffect;
                };
            };
            if (_flowAdjust != 0) then { _peripheralResistanceAdjustment = _peripheralResistanceAdjustment + _flowAdjust * _effectRatio; };
            if (_rrAdjust != 0) then {
                if (_medicationType in _RRAdjustmentMap) then {
                    (_RRAdjustmentMap get _medicationType) params ["_medRRAdjust", "_medMaxRRAdjust"];

                    private _newRRAdjust = _medRRAdjust + _rrAdjust * _effectRatio;
                    private _positive = _medMaxRRAdjust > 0;

                    if ([(_medRRAdjust > (_newRRAdjust max _medMaxRRAdjust)), (_medRRAdjust < (_newRRAdjust min _medMaxRRAdjust))] select _positive) then {
                        private _cappedRRAdjust = [(_newRRAdjust max _medMaxRRAdjust), (_newRRAdjust min _medMaxRRAdjust)] select _positive;
                        _RRAdjustmentMap set [_medicationType, [_cappedRRAdjust, _medMaxRRAdjust]];
                    };
                } else {
                    _respirationRateAdjustment = _respirationRateAdjustment + _rrAdjust * _effectRatio; 
                };
            };
            if (_coSensitivityAdjust != 0) then { _coSensitivityAdjustment = _coSensitivityAdjustment + _coSensitivityAdjust * _effectRatio; };
            if (_breathingEffectivenessAdjust != 0) then { _breathingEffectivenessAdjustment = _breathingEffectivenessAdjustment + _breathingEffectivenessAdjust * _effectRatio; };

            if (_painAdjust != 0) then {
                if (_medicationType in _painSuppressAdjustmentMap) then {
                    (_painSuppressAdjustmentMap get _medicationType) params ["_medPainReduce", "_medMaxPainAdjust"];

                    private _newPainAdjust = _medPainReduce + _painAdjust * _effectRatio;

                    if (_medPainReduce < (_newPainAdjust min _medMaxPainAdjust)) then {
                        _painSuppressAdjustmentMap set [_medicationType, [(_newPainAdjust min _medMaxPainAdjust), _medMaxPainAdjust]];
                    };
                };
            };
        };
    } forEachReversed _adjustments;

    {
        _x params ["_medHRIncrease"];

        _hrTargetAdjustment = _hrTargetAdjustment + _medHRIncrease;
    } forEach ((toArray _HRAdjustmentMap) select 1);

    {
        _x params ["_medRRAdjust"];

        _respirationRateAdjustment = _respirationRateAdjustment + _medRRAdjust;
    } forEach ((toArray _RRAdjustmentMap) select 1);

    {
        _x params ["_medPainAdjust"];

        _painSuppressAdjustment = _painSuppressAdjustment + _medPainAdjust;
    } forEach ((toArray _painSuppressAdjustmentMap) select 1);

    if (_deleted) then {
        _unit setVariable [VAR_MEDICATIONS, _adjustments, true];
        _syncValues = true;
    };
};

private _reactionSeverity = _unit getVariable [QEGVAR(circulation,HemolyticReaction_Severity), 0];

if (_reactionSeverity > 0) then {
    _hrTargetAdjustment = _hrTargetAdjustment + (_reactionSeverity * 15);
    _respirationRateAdjustment = _respirationRateAdjustment - _reactionSeverity * 5;
    _peripheralResistanceAdjustment = _peripheralResistanceAdjustment - _reactionSeverity * 15;
    _breathingEffectivenessAdjustment = _breathingEffectivenessAdjustment - (_reactionSeverity * 0.05);
};

// Update SPO2 intake and usage since last update
private _oxygenSaturation = [_unit, _respirationRateAdjustment, _coSensitivityAdjustment, _breathingEffectivenessAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updateOxygen);

if (_oxygenSaturation < ACM_OXYGEN_HYPOXIA) then { // Severe hypoxia causes heart to give out
    _hrTargetAdjustment = _hrTargetAdjustment - 10 * abs (ACM_OXYGEN_HYPOXIA - _oxygenSaturation);
};

if ((_unit getVariable [QEGVAR(breathing,TensionPneumothorax_State), false]) || (_unit getVariable [QEGVAR(breathing,Hardcore_Pneumothorax), false])) then {
    _hrTargetAdjustment = _hrTargetAdjustment - ([25,35] select (_unit getVariable [QEGVAR(breathing,TensionPneumothorax_State), false]));
} else {
    if (_unit getVariable [QEGVAR(breathing,Pneumothorax_State), 0] > 0) then {
        _hrTargetAdjustment = _hrTargetAdjustment - (5 * (_unit getVariable [QEGVAR(breathing,Pneumothorax_State), 0]));
    };
};

if ((_unit getVariable [QEGVAR(circulation,TransfusedBlood_Volume), 0]) > 0.05) then {
    _hrTargetAdjustment = _hrTargetAdjustment - ((_unit getVariable [QEGVAR(circulation,TransfusedBlood_Volume), 0]) / 0.05);
};

if (EGVAR(CBRN,enable)) then {
    _hrTargetAdjustment = _hrTargetAdjustment - (linearConversion [15, 100, (_unit getVariable [QGVAR_BUILDUP(Chemical_Sarin), 0]), 0, 35, true]) - (linearConversion [15, 100, (_unit getVariable [QGVAR_BUILDUP(Chemical_Lewisite), 0]), 0, 35, true]);
};

private _heartRate = [_unit, _hrTargetAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updateHeartRate);
[_unit, _painSuppressAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updatePainSuppress);

private _vasoconstriction = 0;
private _targetVasoconstriction = 0;

if (_bloodVolume < 5.9) then {
    _targetVasoconstriction = linearConversion [5.9, 4.5, _bloodVolume, 0, 50, true];
};

if (_bloodVolume > 4) then {
    private _MAPAdjustment = 0;
    private _MAP = GET_MAP_PATIENT(_unit);

    if (_MAP > 94) then {
        _MAPAdjustment = linearConversion [94, 120, _MAP, 0, -60, true];
    } else {
        if (_MAP < 88) then {
            _MAPAdjustment = linearConversion [88, 60, _MAP, 0, 40, true];
        };
    };

    _targetVasoconstriction = (_targetVasoconstriction + _MAPAdjustment) min 50;

    if (IS_BLEEDING(_unit) && _targetVasoconstriction < 0) then {
        _targetVasoconstriction = _targetVasoconstriction * 0.75;
    };
};

private _vasoconstrictionChange = (_targetVasoconstriction - _vasoconstriction) / 4;

if (_targetVasoconstriction > _vasoconstriction) then {
    _vasoconstriction = (_vasoconstriction + _vasoconstrictionChange * (_deltaT min 1.2)) min _targetVasoconstriction;
} else {
    _vasoconstriction = (_vasoconstriction + _vasoconstrictionChange * (_deltaT min 1.2)) max _targetVasoconstriction;
};

_unit setVariable [QEGVAR(circulation,Vasoconstriction_State), _vasoconstriction, true];

_peripheralResistanceAdjustment = _peripheralResistanceAdjustment + _vasoconstriction;

[_unit, _peripheralResistanceAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updatePeripheralResistance);

private _bloodPressure = [_unit] call ACEFUNC(medical_status,getBloodPressure);
_unit setVariable [VAR_BLOOD_PRESS, _bloodPressure, _syncValues];

_bloodPressure params ["_BPDiastolic", "_BPSystolic"];

private _respirationRate = GET_RESPIRATION_RATE(_unit);

private _activeGracePeriod = IN_CRITICAL_STATE(_unit);

// Statements are ordered by most lethal first.
switch (true) do {
    case (_bloodVolume < BLOOD_VOLUME_FATAL): {
        TRACE_3("BloodVolume Fatal",_unit,BLOOD_VOLUME_FATAL,_bloodVolume);
        [QACEGVAR(medical,Bleedout), _unit] call CBA_fnc_localEvent;
    };
    case (_oxygenSaturation < ACM_OXYGEN_DEATH): {
        if (ACM_OXYGEN_DEATH - (random 5) > _oxygenSaturation) then {
            [_unit, "Oxygen Deprivation"] call ACEFUNC(medical_status,setDead);
        };
    };
    case (IN_CRDC_ARRST(_unit)): {}; // if in cardiac arrest just break now to avoid throwing unneeded events
    case ([_unit] call EFUNC(circulation,recentAEDShock)): {};
    case (_hemorrhage == 4): {
        TRACE_3("Class IV Hemorrhage",_unit,_hemorrhage,_bloodVolume);
        [QACEGVAR(medical,FatalVitals), _unit] call CBA_fnc_localEvent;
        [_unit] call EFUNC(circulation,updateCirculationState);
    };
    case ((_unit getVariable [QEGVAR(circulation,ROSC_Time), 0]) + 10 > CBA_missionTime): {};
    case (_oxygenSaturation < ACM_OXYGEN_HYPOXIA): {
        private _nextCheck = _unit getVariable [QEGVAR(circulation,ReversibleCardiacArrest_HypoxiaTime), CBA_missionTime];
        private _enterCardiacArrest = false;
        if (CBA_missionTime >= _nextCheck) then {
            _enterCardiacArrest = (ACM_OXYGEN_HYPOXIA - (random 10) > _oxygenSaturation);
            _unit setVariable [QEGVAR(circulation,ReversibleCardiacArrest_HypoxiaTime), CBA_missionTime + 5];
            [_unit] call EFUNC(circulation,updateCirculationState);
        };
        if (_enterCardiacArrest) then {
            [QACEGVAR(medical,FatalVitals), _unit] call CBA_fnc_localEvent;
        } else {
            [QACEGVAR(medical,CriticalVitals), _unit] call CBA_fnc_localEvent;
        };
    };
    case (!_activeGracePeriod && {_heartRate < 40 || {_heartRate > 220}}): {
        TRACE_2("heartRate Fatal",_unit,_heartRate);
        if (_heartRate > 220) then {
            _unit setVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_VT, true];
            _unit setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_PVT];
        } else {
            if ([_unit, "Adenosine_IV", false] call ACEFUNC(medical_status,getMedicationCount) > 0.5) then {
                _unit setVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_Asystole, true];
                _unit setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_Asystole];
            } else {
                _unit setVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_VF, true];
                _unit setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_VF];
            };
        };
        [QGVAR(handleFatalVitals), _unit] call CBA_fnc_localEvent;
    };
    case (GET_MAP(_BPSystolic,_BPDiastolic) < 55): {
        [QGVAR(handleFatalVitals), _unit] call CBA_fnc_localEvent;
    };
    case (GET_MAP(_BPSystolic,_BPDiastolic) > 200): {
        [QGVAR(handleFatalVitals), _unit] call CBA_fnc_localEvent;
    };
    case (IS_UNCONSCIOUS(_unit)): {}; // Already unconscious
    case (_woundBloodLoss > BLOOD_LOSS_KNOCK_OUT_THRESHOLD): {
        [QACEGVAR(medical,CriticalVitals), _unit] call CBA_fnc_localEvent;
    };
    case (_oxygenSaturation < ACM_OXYGEN_UNCONSCIOUS): {
        if (ACM_OXYGEN_UNCONSCIOUS - (random 10) > _oxygenSaturation) then {
            [QACEGVAR(medical,CriticalVitals), _unit] call CBA_fnc_localEvent;
        };
    };
    case (_respirationRate < 6): {
        [QACEGVAR(medical,CriticalVitals), _unit] call CBA_fnc_localEvent;
    };
    case (_woundBloodLoss > 0): {
        [QACEGVAR(medical,LoweredVitals), _unit] call CBA_fnc_localEvent;
    };
    case (_inPain): {
        [QACEGVAR(medical,LoweredVitals), _unit] call CBA_fnc_localEvent;
    };
};

#ifdef DEBUG_MODE_FULL
private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);
if (!isPlayer _unit) then {
    private _painLevel = _unit getVariable [VAR_PAIN, 0];
    hintSilent format["blood volume: %1, blood loss: [%2, %3]\nhr: %4, bp: %5, pain: %6", round(_bloodVolume * 100) / 100, round(_woundBloodLoss * 1000) / 1000, round((_woundBloodLoss / (0.001 max _cardiacOutput)) * 100) / 100, round(_heartRate), _bloodPressure, round(_painLevel * 100) / 100];
};
#endif

END_COUNTER(Vitals);

//placed outside the counter as 3rd-party code may be called from this event
[QACEGVAR(medical,handleUnitVitals), [_unit, _deltaT]] call CBA_fnc_localEvent;

true
