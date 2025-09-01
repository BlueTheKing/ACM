#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to create evacuation point in eden.
 *
 * Arguments:
 * 0: The module logic <OBJECT>
 * 1: Synchronized units <ARRAY>
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

params ["_logic", "", "_activated"];

if (!_activated || !(GVAR(enable))) exitWith {};

private _syncedObjects = synchronizedObjects _logic;
private _sideSelection = _logic getVariable ["Side", 0];

{
    [_x, _sideSelection] call FUNC(defineEvacuationPoint);
} forEach _syncedObjects;