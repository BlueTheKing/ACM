#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_evacuation_fnc_initUnit;
 *
 * Public: No
 */

params ["_unit"];

if !(isPlayer _unit) exitWith {};

if !(local _unit) exitWith {};

if (_unit getVariable [QGVAR(playerSpawned), false]) exitWith {};

[{
    params ["_unit"];

    _unit setVariable [QGVAR(playerSpawned), true];
}, [_unit], 0.5] call CBA_fnc_waitAndExecute;