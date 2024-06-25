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
 * 5: Incompatable medication <ARRAY<STRING>>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "morphine", 4, 2, [["x", 1]]] call ace_medical_treatment_fnc_onMedicationUsage
 *
 * Public: No
 */

params ["_target", "_className", "_maxDose", "_maxDoseDeviation", "_doseConcentration", "_incompatibleMedication"];
TRACE_5("onMedicationUsage",_target,_className,_maxDose,_maxDoseDeviation,_incompatibleMedication);

private _overdosedMedications = [];

if (_maxDose < 1) exitWith {};

// Check for overdose from current medication
private _currentDose = [_target, _className] call ACEFUNC(medical_status,getMedicationCount);

private _doseDeviation = 0;

// Because both {floor random 0} and {floor random 1} return 0
if (_maxDoseDeviation > 0) then {
    _maxDoseDeviation = _maxDoseDeviation + 1;
    _doseDeviation = floor (random _maxDoseDeviation);
};

if (_currentDose > _maxDose + _doseDeviation) then {
    [_target, _className, _maxDose, _doseDeviation] call EFUNC(circulation,handleOverdose);
} else {
    if (_doseConcentration > _maxDose + _doseDeviation) then {
        [_target, _className, _maxDose, _doseDeviation] call EFUNC(circulation,handleOverdose);
    };
};