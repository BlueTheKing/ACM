#include "..\script_component.hpp"
/*
 * Author: Glowbal, mharis001
 * Local callback for administering medication to a patient.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Treatment <STRING>
 * 3: Medication Dose <NUMBER>
 * 4: Is IV? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "RightArm", "Morphine", 1] call ace_medical_treatment_fnc_medicationLocal
 *
 * Public: No
 */

// todo: move this macro to script_macros_medical.hpp?
#define MORPHINE_PAIN_SUPPRESSION 0.6
// 0.2625 = 0.6/0.8 * 0.35
// 0.6 = basic medication morph. pain suppr., 0.8 = adv. medication morph. pain suppr., 0.35 = adv. medication painkillers. pain suppr.
#define PAINKILLERS_PAIN_SUPPRESSION 0.2625 

params ["_patient", "_bodyPart", "_classname", ["_dose", 1], ["_iv", false]];
TRACE_3("medicationLocal",_patient,_bodyPart,_classname);

// Medication has no effects on dead units
if (!alive _patient) exitWith {};

// Exit with basic medication handling if advanced medication not enabled
if (!ACEGVAR(medical_treatment,advancedMedication)) exitWith {
    switch (_classname) do {
        case "Morphine": {
            private _painSuppress = GET_PAIN_SUPPRESS(_patient);
            _patient setVariable [VAR_PAIN_SUPP, (_painSuppress + MORPHINE_PAIN_SUPPRESSION) min 1, true];
        };
        case "Epinephrine": {
            [QACEGVAR(medical,WakeUp), _patient] call CBA_fnc_localEvent;
        };
        case "Painkillers": {
            private _painSuppress = GET_PAIN_SUPPRESS(_patient);
            _patient setVariable [VAR_PAIN_SUPP, (_painSuppress + PAINKILLERS_PAIN_SUPPRESSION) min 1, true];
        };
    };
};
TRACE_1("Running treatmentMedicationLocal with Advanced configuration for",_patient);


// Handle tourniquet on body part blocking blood flow at injection site
private _partIndex = ALL_BODY_PARTS find tolowerANSI _bodyPart;

if (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex) && (!_iv || (_iv && (!([_patient, _bodyPart] call EFUNC(circulation,hasIO)) || _partIndex > 3)))) exitWith {
    TRACE_1("unit has tourniquets blocking blood flow on injection site",_tourniquets);
    private _occludedMedications = _patient getVariable [QACEGVAR(medical,occludedMedications), []];
    _occludedMedications pushBack [_partIndex, _classname, _dose, _iv];
    _patient setVariable [QACEGVAR(medical,occludedMedications), _occludedMedications, true];
};

// Get adjustment attributes for used medication
private _defaultConfig = configFile >> "ACM_Medication" >> "Medications";
private _medicationConfig = _defaultConfig >> _classname;

private _painReduce             = GET_NUMBER(_medicationConfig >> "painReduce",getNumber (_defaultConfig >> "painReduce"));
private _timeInSystem           = GET_NUMBER(_medicationConfig >> "timeInSystem",getNumber (_defaultConfig >> "timeInSystem"));
private _timeTillMaxEffect      = GET_NUMBER(_medicationConfig >> "timeTillMaxEffect",getNumber (_defaultConfig >> "timeTillMaxEffect"));
private _maxDose                = GET_NUMBER(_medicationConfig >> "maxDose",getNumber (_defaultConfig >> "maxDose"));
private _maxDoseDeviation       = GET_NUMBER(_medicationConfig >> "maxDoseDeviation",getNumber (_defaultConfig >> "maxDoseDeviation"));
private _viscosityChange        = GET_NUMBER(_medicationConfig >> "viscosityChange",getNumber (_defaultConfig >> "viscosityChange"));
private _hrIncreaseLow          = GET_ARRAY(_medicationConfig >> "hrIncreaseLow",getArray (_defaultConfig >> "hrIncreaseLow"));
private _hrIncreaseNormal       = GET_ARRAY(_medicationConfig >> "hrIncreaseNormal",getArray (_defaultConfig >> "hrIncreaseNormal"));
private _hrIncreaseHigh         = GET_ARRAY(_medicationConfig >> "hrIncreaseHigh",getArray (_defaultConfig >> "hrIncreaseHigh"));
private _incompatibleMedication = GET_ARRAY(_medicationConfig >> "incompatibleMedication",getArray (_defaultConfig >> "incompatibleMedication"));

private _administrationType = GET_NUMBER(_medicationConfig >> "administrationType",getNumber (_defaultConfig >> "administrationType"));
private _maxEffectTime = GET_NUMBER(_medicationConfig >> "maxEffectTime",getNumber (_defaultConfig >> "maxEffectTime"));

private _heartRate = GET_HEART_RATE(_patient);
private _hrIncrease = [_hrIncreaseLow, _hrIncreaseNormal, _hrIncreaseHigh] select (floor ((0 max _heartRate min 110) / 55));
_hrIncrease params ["_minIncrease", "_maxIncrease"];
private _heartRateChange = _minIncrease + random (_maxIncrease - _minIncrease);

private _rrAdjust = GET_ARRAY(_medicationConfig >> "rrAdjust",getArray (_defaultConfig >> "rrAdjust"));
private _rrAdjustment = 0;

if ((_rrAdjust select 0) + (_rrAdjust select 1) != 0) then {
    _rrAdjustment = random [(_rrAdjust select 0), (((_rrAdjust select 0) + (_rrAdjust select 1)) / 2), (_rrAdjust select 1)];
};

private _coSensitivityAdjust = GET_ARRAY(_medicationConfig >> "coSensitivityAdjust",getArray (_defaultConfig >> "coSensitivityAdjust"));
private _coSensitivityAdjustment = 0;

if ((_coSensitivityAdjust select 0) + (_coSensitivityAdjust select 1) != 0) then {
    _coSensitivityAdjustment = random [(_coSensitivityAdjust select 0), (((_coSensitivityAdjust select 0) + (_coSensitivityAdjust select 1)) / 2), (_coSensitivityAdjust select 1)];
};

private _breathingEffectivenessAdjust = GET_ARRAY(_medicationConfig >> "breathingEffectivenessAdjust",getArray (_defaultConfig >> "breathingEffectivenessAdjust"));
private _breathingEffectivenessAdjustment = 0;

if ((_breathingEffectivenessAdjust select 0) + (_breathingEffectivenessAdjust select 1) != 0) then {
    _breathingEffectivenessAdjustment = random [(_breathingEffectivenessAdjust select 0), (((_breathingEffectivenessAdjust select 0) + (_breathingEffectivenessAdjust select 1)) / 2), (_breathingEffectivenessAdjust select 1)];
};

private _weightEffect = GET_NUMBER(_medicationConfig >> "weightEffect",getNumber (_defaultConfig >> "weightEffect"));
private _maxEffectDose = GET_NUMBER(_medicationConfig >> "maxEffectDose",getNumber (_defaultConfig >> "maxEffectDose"));

private _patientWeight = GET_BODYWEIGHT(_patient);

private _concentrationRatio = 1;

if (_weightEffect == 1) then {
    private _weightModifier = IDEAL_BODYWEIGHT / _patientWeight;

    _concentrationRatio = (_dose * _weightModifier) / _maxEffectDose;
} else {
    _concentrationRatio = _dose / _maxEffectDose;
};

private _medicationType = GET_STRING(_medicationConfig >> "medicationType",getText (_defaultConfig >> "medicationType"));

// Adjust the medication effects and add the medication to the list
TRACE_3("adjustments",_heartRateChange,_painReduce,_viscosityChange);

private _continue = true;
if (_partIndex == 0 && GET_AIRWAYSTATE(_patient) < 0.9) then {
    if (GET_AIRWAYSTATE(_patient) == 0) then {
        if (_classname == "Naloxone") else {
            _continue = false;
        };
    } else {
        if !(_classname in ACM_NASAL_MEDICATION) then {
            _concentrationRatio = _concentrationRatio * (GET_AIRWAYSTATE(_patient) max 0.1);
        };
    };
};

if !(_continue) exitWith {};

[_patient, _classname, _timeTillMaxEffect / (0.1 max _concentrationRatio min 1.2), _timeInSystem * (0.1 max _concentrationRatio min 1.2), _heartRateChange * _concentrationRatio, _painReduce * _concentrationRatio, _viscosityChange * _concentrationRatio, _administrationType, _maxEffectTime * (0.01 max _concentrationRatio min 1.1), _rrAdjustment * _concentrationRatio, _coSensitivityAdjustment * _concentrationRatio, _breathingEffectivenessAdjustment * _concentrationRatio, _concentrationRatio, _medicationType] call ACEFUNC(medical_status,addMedicationAdjustment);

// Check for medication compatiblity
[_patient, _classname, _maxDose, _maxDoseDeviation, _concentrationRatio, _maxEffectDose, _patientWeight, _incompatibleMedication] call ACEFUNC(medical_treatment,onMedicationUsage);

[QEGVAR(circulation,handleMedicationEffects), [_patient, _bodyPart, _classname, _dose]] call CBA_fnc_localEvent;
