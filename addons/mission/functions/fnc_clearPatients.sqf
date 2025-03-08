#include "..\script_component.hpp"
/*
 * Author: Blue
 * Clear all patients from active patient list.
 *
 * Arguments:
 * 0: Interaction Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object] call ACM_mission_fnc_clearPatients;
 *
 * Public: No
 */

params ["_object"];

private _activePatients = _object getVariable [QGVAR(ActivePatients), []];

if (count _activePatients < 1) exitWith {};

{
    deleteVehicle _x;
} forEachReversed _activePatients;

_object setVariable [QGVAR(ActivePatients), [], true];