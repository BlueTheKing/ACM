#include "..\script_component.hpp"
/*
 * Author: Blue
 * Do stuff on respawn.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Dead body <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [alive, body] call ACM_evacuation_fnc_onRespawn;
 *
 * Public: No
 */

params ["_unit", "_dead"];

if !(isMultiplayer) exitWith {};

if !(local _unit) exitWith {};

if !(isPlayer _unit) exitWith {};

_unit setVariable [QGVAR(playerSpawned), true];