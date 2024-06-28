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
    case (_bloodVolume < BLOOD_VOLUME_CLASS_1_HEMORRHAGE): { 1 };
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
private _painSupressAdjustment = 0;
private _peripheralResistanceAdjustment = 0;
private _respirationRateAdjustment = 0;
private _coSensitivityAdjustment = 0;
private _breathingEffectivenessAdjustment = 0;
private _adjustments = _unit getVariable [VAR_MEDICATIONS,[]];

private _painSuppressAdjustmentMap = +GVAR(MedicationTypes);

if (_adjustments isNotEqualTo []) then {
    private _deleted = false;
    {
        _x params ["_medication", "_timeAdded", "_timeTillMaxEffect", "_maxTimeInSystem", "_hrAdjust", "_painAdjust", "_flowAdjust", "_administrationType", "_maxEffectTime", "_rrAdjust", "_coSensitivityAdjust", "_breathingEffectivenessAdjust", "_concentration", "_medicationType"];
        private _timeInSystem = CBA_missionTime - _timeAdded;
        if (_timeInSystem >= _maxTimeInSystem) then {
            _deleted = true;
            _adjustments set [_forEachIndex, objNull];
        } else {
            private _effectRatio = [_administrationType, _timeInSystem, _timeTillMaxEffect, _maxTimeInSystem, _maxEffectTime, _concentration] call EFUNC(circulation,getMedicationEffect);
            if (_hrAdjust != 0) then { _hrTargetAdjustment = _hrTargetAdjustment + _hrAdjust * _effectRatio; };
            if (_flowAdjust != 0) then { _peripheralResistanceAdjustment = _peripheralResistanceAdjustment + _flowAdjust * _effectRatio; };
            if (_rrAdjust != 0) then { _respirationRateAdjustment = _respirationRateAdjustment + _rrAdjust * _effectRatio; };
            if (_coSensitivityAdjust != 0) then { _coSensitivityAdjustment = _coSensitivityAdjustment + _coSensitivityAdjust * _effectRatio; };
            if (_breathingEffectivenessAdjust != 0) then { _breathingEffectivenessAdjustment = _breathingEffectivenessAdjustment + _breathingEffectivenessAdjust * _effectRatio; };

            if (_painAdjust != 0) then {
                if (_medicationType == "Default") then {
                    _medicationType = _medication;
                };
                (_painSuppressAdjustmentMap get _medicationType) params ["_medClassnames", "_medPainReduce", "_medMaxPainAdjust"];
                if (_medication in _medClassnames) then {
                    private _newPainAdjust = _medPainReduce + _painAdjust * _effectRatio;

                    if (_medPainReduce < (_newPainAdjust min _medMaxPainAdjust)) then {
                        _painSuppressAdjustmentMap set [_medicationType, [_medClassnames, (_newPainAdjust min _medMaxPainAdjust), _medMaxPainAdjust]];
                    };
                };
            };
        };
    } forEach _adjustments;

    {
        _y params ["", "_medPainAdjust", "_medMaxPainAdjust"];

        _painSupressAdjustment = _painSupressAdjustment + (_medPainAdjust min _medMaxPainAdjust);
    } forEach _painSuppressAdjustmentMap;

    if (_deleted) then {
        _unit setVariable [VAR_MEDICATIONS, _adjustments - [objNull], true];
        _syncValues = true;
    };
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

private _heartRate = [_unit, _hrTargetAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updateHeartRate);
[_unit, _painSupressAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updatePainSuppress);
[_unit, _peripheralResistanceAdjustment, _deltaT, _syncValues] call ACEFUNC(medical_vitals,updatePeripheralResistance);

private _bloodPressure = [_unit] call ACEFUNC(medical_status,getBloodPressure);
_unit setVariable [VAR_BLOOD_PRESS, _bloodPressure, _syncValues];

_bloodPressure params ["_bloodPressureL", "_bloodPressureH"];

private _respirationRate = GET_RESPIRATION_RATE(_unit);

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
    case (_heartRate < 20 || {_heartRate > 220}): {
        TRACE_2("heartRate Fatal",_unit,_heartRate);
        if (_heartRate > 220) then {
            _unit setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), 3];
        } else {
            _unit setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), 2];
        };

        [QACEGVAR(medical,FatalVitals), _unit] call CBA_fnc_localEvent;
    };
    case (_bloodPressureH < 50 && {_bloodPressureL < 40}): {
        _unit setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), 2];
        [QACEGVAR(medical,FatalVitals), _unit] call CBA_fnc_localEvent;
    };
    case (_bloodPressureL >= 190): {
        TRACE_2("bloodPressure L above limits",_unit,_bloodPressureL);
        _unit setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), 3];
        [QACEGVAR(medical,FatalVitals), _unit] call CBA_fnc_localEvent;
    };
    case (_heartRate < 30): {  // With a heart rate below 30 but bigger than 20 there is a chance to enter the cardiac arrest state
        private _nextCheck = _unit getVariable [QACEGVAR(medical_vitals,nextCheckCriticalHeartRate), CBA_missionTime];
        private _enterCardiacArrest = false;
        if (CBA_missionTime >= _nextCheck) then {
            _enterCardiacArrest = random 1 < (0.4 + 0.6*(30 - _heartRate)/10); // Variable chance of getting into cardiac arrest.
            _unit setVariable [QACEGVAR(medical_vitals,nextCheckCriticalHeartRate), CBA_missionTime + 5];
        };
        if (_enterCardiacArrest) then {
            TRACE_2("Heart rate critical. Cardiac arrest",_unit,_heartRate);
            _unit setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), 2];
            [QACEGVAR(medical,FatalVitals), _unit] call CBA_fnc_localEvent;
        } else {
            TRACE_2("Heart rate critical. Critical vitals",_unit,_heartRate);
            [QACEGVAR(medical,CriticalVitals), _unit] call CBA_fnc_localEvent;
        };
    };
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
    case (_woundBloodLoss > BLOOD_LOSS_KNOCK_OUT_THRESHOLD_DEFAULT): {
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
