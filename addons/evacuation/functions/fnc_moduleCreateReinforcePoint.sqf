#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to create reinforce point in eden.
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
 * [LOGIC, [], true] call ACM_evacuation_fnc_moduleCreateReinforcePoint;
 *
 * Public: No
 */

params ["_logic", "", "_activated"];

if (!_activated || !(GVAR(enable))) exitWith {};

private _sideSelection = _logic getVariable ["Side", 0];

[_logic, _sideSelection] call FUNC(defineReinforcePoint);