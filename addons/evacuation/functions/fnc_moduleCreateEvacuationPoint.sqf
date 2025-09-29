#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to create evacuation point in eden.
 *
 * Arguments:
 * 0: The module logic <OBJECT>
 * 1: Synchronized objects <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC, [], true] call ACM_evacuation_fnc_moduleCreateEvacuationPoint;
 *
 * Public: No
 */

params ["_logic", "_syncedObjects", "_activated"];

if (!_activated || !(GVAR(enable))) exitWith {};

private _sideSelection = _logic getVariable ["Side", 0];

private _distance = (_logic getVariable ["InteractionDistance", 5]) max 0;
private _position = _logic getVariable ["InteractionPosition", [0,0,0]];

if (typeName _position == "STRING") then {
    _position = (_position select [1, ((count _position) - 2)]) splitString ",";
};

if ((typeName _position != "ARRAY") || {count _position != 3}) then {
    _position = [0,0,0];
} else {
    {
        _position set [_forEachIndex, (parseNumber _x)];
    } forEach _position;
};

{
    [_x, _sideSelection, _distance, _position] call FUNC(defineEvacuationPoint);
} forEach _syncedObjects;