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
 * [alive, body] call AMS_core_fnc_handleRespawn;
 */

params ["_unit", "_dead"];

if !(local _unit) exitWith {};

[_unit] call EFUNC(airway,resetVariables);
[_unit] call EFUNC(breathing,resetVariables);
[_unit] call EFUNC(circulation,resetVariables);