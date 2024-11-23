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
private _partIndex = ALL_BODY_PARTS find toLowerANSI _bodyPart;

if (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex) && (!_iv || (_iv && (!([_patient, _bodyPart] call EFUNC(circulation,hasIO)) || _partIndex > 3)))) exitWith {
    TRACE_1("unit has tourniquets blocking blood flow on injection site",_tourniquets);
    private _occludedMedications = _patient getVariable [QACEGVAR(medical,occludedMedications), []];
    _occludedMedications pushBack [_partIndex, _classname, _dose, _iv];
    _patient setVariable [QACEGVAR(medical,occludedMedications), _occludedMedications, true];
};

// Get adjustment attributes for used medication
private _defaultConfig = configFile >> "ACM_Medication" >> "Medications";
private _medicationConfig = _defaultConfig >> _classname;

private _timeInSystem           = GET_NUMBER(_medicationConfig >> "timeInSystem",getNumber (_defaultConfig >> "timeInSystem"));
private _timeTillMaxEffect      = GET_NUMBER(_medicationConfig >> "timeTillMaxEffect",getNumber (_defaultConfig >> "timeTillMaxEffect"));
private _maxDose                = GET_NUMBER(_medicationConfig >> "maxDose",getNumber (_defaultConfig >> "maxDose"));
private _maxDoseDeviation       = GET_NUMBER(_medicationConfig >> "maxDoseDeviation",getNumber (_defaultConfig >> "maxDoseDeviation"));
private _viscosityChange        = GET_NUMBER(_medicationConfig >> "viscosityChange",getNumber (_defaultConfig >> "viscosityChange"));
private _hrIncrease             = GET_ARRAY(_medicationConfig >> "hrIncrease",getArray (_defaultConfig >> "hrIncrease"));
private _incompatibleMedication = GET_ARRAY(_medicationConfig >> "incompatibleMedication",getArray (_defaultConfig >> "incompatibleMedication"));

private _administrationType = GET_NUMBER(_medicationConfig >> "administrationType",getNumber (_defaultConfig >> "administrationType"));
private _maxEffectTime = GET_NUMBER(_medicationConfig >> "maxEffectTime",getNumber (_defaultConfig >> "maxEffectTime"));

private _minEffectDose = GET_NUMBER(_medicationConfig >> "minEffectDose",getNumber (_defaultConfig >> "minEffectDose"));
private _maxEffectDose = GET_NUMBER(_medicationConfig >> "maxEffectDose",getNumber (_defaultConfig >> "maxEffectDose"));

private _painReduce = GET_NUMBER(_medicationConfig >> "painReduce",getNumber (_defaultConfig >> "painReduce"));
private _minPainReduce = GET_NUMBER(_medicationConfig >> "minPainReduce",getNumber (_defaultConfig >> "minPainReduce"));
private _maxPainReduce = GET_NUMBER(_medicationConfig >> "maxPainReduce",getNumber (_defaultConfig >> "maxPainReduce"));

private _weightEffect = GET_NUMBER(_medicationConfig >> "weightEffect",getNumber (_defaultConfig >> "weightEffect"));

private _patientWeight = GET_BODYWEIGHT(_patient);

private _concentrationRatio = 1;

switch (_weightEffect) do {
    case 1: {
        private _weightModifier = [(linearConversion [IDEAL_BODYWEIGHT, 75, _patientWeight, 1, 1.1]), (linearConversion [IDEAL_BODYWEIGHT, 91, _patientWeight, 1, 0.9])] select (_patientWeight > IDEAL_BODYWEIGHT);
        private _weightedDose = _dose * _weightModifier;

        _concentrationRatio = _weightedDose / _maxEffectDose;

        if (_painReduce != 0) then {
            _painReduce = [(linearConversion [_minEffectDose, 0, _weightedDose, _minPainReduce, 0]), (linearConversion [_minEffectDose, _maxEffectDose, _weightedDose, _minPainReduce, _painReduce])] select (_weightedDose > _minEffectDose);
        };
    };
    case 2: {
        private _weightModifier = [(linearConversion [IDEAL_BODYWEIGHT, 75, _patientWeight, 1, 1.01]), (linearConversion [IDEAL_BODYWEIGHT, 91, _patientWeight, 1, 0.99])] select (_patientWeight > IDEAL_BODYWEIGHT);
        private _weightedDose = _dose * (_weightModifier ^ 2);

        _concentrationRatio = _weightedDose / _maxEffectDose;

        if (_painReduce != 0) then {
            _painReduce = [(linearConversion [_minEffectDose, 0, _weightedDose, _minPainReduce, 0]), (linearConversion [_minEffectDose, _maxEffectDose, _weightedDose, _minPainReduce, _painReduce])] select (_weightedDose > _minEffectDose);
        };
    };
    default {
        _concentrationRatio = _dose / _maxEffectDose;

        if (_painReduce != 0) then {
            _painReduce = (linearConversion [_minEffectDose, _maxEffectDose, _dose, _minPainReduce, _painReduce]) min _maxPainReduce;
        };
    };
};

private _heartRateChange = 0;

_hrIncrease params ["_hrIncreaseLow", "_hrIncreaseHigh"];

if ((_hrIncreaseLow + _hrIncreaseHigh) != 0) then {
    private _heartRate = GET_HEART_RATE(_patient);
    _heartRateChange = linearConversion [0.5, 1, _concentrationRatio, _hrIncreaseLow, _hrIncreaseHigh];
};

private _rrAdjust = GET_ARRAY(_medicationConfig >> "rrAdjust",getArray (_defaultConfig >> "rrAdjust"));
private _rrAdjustment = 0;

if ((_rrAdjust select 0) + (_rrAdjust select 1) != 0) then {
    _rrAdjustment = linearConversion [_minEffectDose, _maxEffectDose, (_maxEffectDose * _concentrationRatio), (_rrAdjust select 0), (_rrAdjust select 1)];
};

private _coSensitivityAdjust = GET_ARRAY(_medicationConfig >> "coSensitivityAdjust",getArray (_defaultConfig >> "coSensitivityAdjust"));
private _coSensitivityAdjustment = 0;

if ((_coSensitivityAdjust select 0) + (_coSensitivityAdjust select 1) != 0) then {
    _coSensitivityAdjustment = linearConversion [_minEffectDose, _maxEffectDose, (_maxEffectDose * _concentrationRatio), (_coSensitivityAdjust select 0), (_coSensitivityAdjust select 1)];
};

private _breathingEffectivenessAdjust = GET_ARRAY(_medicationConfig >> "breathingEffectivenessAdjust",getArray (_defaultConfig >> "breathingEffectivenessAdjust"));
private _breathingEffectivenessAdjustment = 0;

if ((_breathingEffectivenessAdjust select 0) + (_breathingEffectivenessAdjust select 1) != 0) then {
    _breathingEffectivenessAdjustment = linearConversion [_minEffectDose, _maxEffectDose, (_maxEffectDose * _concentrationRatio), (_breathingEffectivenessAdjust select 0), (_breathingEffectivenessAdjust select 1)];
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

[_patient, _classname, _timeTillMaxEffect / (0.5 max _concentrationRatio min 1.1), _timeInSystem * (0.5 max _concentrationRatio min 1.1), _heartRateChange, _painReduce, _viscosityChange * _concentrationRatio, _administrationType, _maxEffectTime * (0.01 max _concentrationRatio min 1.1), _rrAdjustment, _coSensitivityAdjustment, _breathingEffectivenessAdjustment, _concentrationRatio, _medicationType] call ACEFUNC(medical_status,addMedicationAdjustment);

// Check for medication compatiblity
[_patient, _classname, _maxDose, _maxDoseDeviation, _concentrationRatio, _maxEffectDose, _patientWeight, _incompatibleMedication] call ACEFUNC(medical_treatment,onMedicationUsage);

[QEGVAR(circulation,handleMedicationEffects), [_patient, _bodyPart, _classname, _dose]] call CBA_fnc_localEvent;
