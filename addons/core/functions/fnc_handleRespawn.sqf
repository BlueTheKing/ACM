#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset unit variables on respawn.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Dead body <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [alive, body] call ACM_core_fnc_handleRespawn;
 *
 * Public: No
 */

params ["_unit", "_dead"];

if !(local _unit) exitWith {};

[_unit] call FUNC(resetVariables);
[_unit] call EFUNC(airway,resetVariables);
[_unit] call EFUNC(breathing,resetVariables);
[_unit] call EFUNC(circulation,resetVariables);
[_unit] call EFUNC(damage,resetVariables);
[_unit] call EFUNC(disability,resetVariables);