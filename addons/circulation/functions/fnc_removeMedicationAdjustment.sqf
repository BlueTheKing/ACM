#include "..\script_component.hpp"
/*
 * Author: Blue
 * Remove medication from medication array.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Target Medication <STRING>
 * 2: Remove Amount <NUMBER>
 *
 * Return Value:
 * Medication Adjustment Array <ARRAY<ARRAY>>
 *
 * Example:
 * [player, "Overdose_Opioid", 1] call ACM_circulation_fnc_removeMedicationAdjustment;
 *
 * Public: No
 */

params ["_patient", "_targetMedication", ["_amount", 0]];

private _medicationArray = _patient getVariable [VAR_MEDICATIONS, []];
private _returnedMedication = [];
private _found = 0;

{
    _x params ["_medicationClassname", "_injectTime", "_timeToMaxEffect", "_maxTimeInSystem", "_hrAdjust", "_painAdjust", "_flowAdjust", "_administrationType", "_maxEffectTime", "_rrAdjust", "_coSensitivityAdjust", "_breathingEffectivenessAdjust", "_concentration", "_medicationType"];
    
    if (_medicationClassname == _targetMedication) then {
        _returnedMedication pushBack (+_medicationArray select _forEachIndex);
        _medicationArray deleteAt _forEachIndex;
        _found = _found + 1;
        if (_amount != 0 && _found >= _amount) then {
            break;
        };
    };
} forEachReversed _medicationArray;

_patient setVariable [VAR_MEDICATIONS, _medicationArray, true];

_returnedMedication;