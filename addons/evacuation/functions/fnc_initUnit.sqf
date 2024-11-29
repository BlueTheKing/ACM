#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init unit.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_evacuation_fnc_initUnit;
 *
 * Public: No
 */

params ["_patient"];

if !(isPlayer _patient) exitWith {};

if !(local _patient) exitWith {};

if (_patient getVariable [QGVAR(playerSpawned), false]) exitWith {};

[{
    params ["_patient"];

    _patient setVariable [QGVAR(playerSpawned), true];
}, [_patient], 0.5] call CBA_fnc_waitAndExecute;