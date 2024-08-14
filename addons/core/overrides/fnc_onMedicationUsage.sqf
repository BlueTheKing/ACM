#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Handles the medication given to a patient.
 *
 * Arguments:
 * 0: The patient <OBJECT>
 * 1: Medication Treatment classname <STRING>
 * 2: Max dose (0 to ignore) <NUMBER>
 * 3: Max dose deviation <NUMBER>
 * 4: Dose Concentration <NUMBER>
 * 5: Max Effect Dose <NUMBER>
 * 6: Patient Weight <NUMBER>
 * 7: Incompatable medication <ARRAY<STRING>>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "morphine", 10, 2, 1, 6, 83, [["x", 1]]] call ace_medical_treatment_fnc_onMedicationUsage
 *
 * Public: No
 */

params ["_target", "_className", "_maxDose", "_maxDoseDeviation", "_doseConcentration", "_maxEffectDose", "_weight", "_incompatibleMedication"];
TRACE_5("onMedicationUsage",_target,_className,_maxDose,_maxDoseDeviation,_incompatibleMedication);

private _overdosedMedications = [];

if (_maxDose < 1) exitWith {};

// Check for overdose from current medication
private _medicationCount = [_target, _className, false] call ACEFUNC(medical_status,getMedicationCount);

private _doseDeviation = 0;

if (_maxDoseDeviation > 0) then {
    _doseDeviation = random (linearConversion [75, 100, _weight, 0, _maxDoseDeviation, true]);
};

if ((_medicationCount * _maxEffectDose) > _maxDose + _doseDeviation) then {
    [_target, _className, _maxDose, _doseDeviation, _doseConcentration, _maxEffectDose] call EFUNC(circulation,handleOverdose);
} else {
    if ((_doseConcentration * _maxEffectDose) > _maxDose + _doseDeviation) then {
        [_target, _className, _maxDose, _doseDeviation, _doseConcentration, _maxEffectDose] call EFUNC(circulation,handleOverdose);
    };
};