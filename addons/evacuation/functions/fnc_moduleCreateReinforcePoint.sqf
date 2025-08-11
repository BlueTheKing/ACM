#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to create reinforce point in eden.
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
 * [LOGIC, [], true] call ACM_evacuation_fnc_moduleCreateReinforcePoint;
 *
 * Public: No
 */

params ["_logic", "", "_activated"];

if (!_activated || !(GVAR(enable))) exitWith {};

[{
    params ["_logic"];

    private _sideSelection = _logic getVariable ["Side", 0];

    [_logic, _sideSelection] call FUNC(defineReinforcePoint);
}, [_logic], 1] call CBA_fnc_waitAndExecute;