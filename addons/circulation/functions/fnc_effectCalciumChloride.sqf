#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Calcium Chloride effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Dose <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 1000] call ACM_circulation_fnc_effectCalciumChloride;
 *
 * Public: No
 */

params ["_patient", ["_dose", 0]];

if (_dose < 900) exitWith {};

private _given = 2 * (_dose / 1000);

if !(_patient getVariable [QGVAR(Calcium_FirstDose), false]) then {
    _patient setVariable [QGVAR(Calcium_FirstDose), true, true];

    _given = _given + (0.5 * (_dose / 1000));
};

private _calciumCount = _patient getVariable [QGVAR(Calcium_Count), 0];

_patient setVariable [QGVAR(Calcium_Count), (_calciumCount + _given), true];