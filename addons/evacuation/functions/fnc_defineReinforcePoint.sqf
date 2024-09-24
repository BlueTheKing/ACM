#include "..\script_component.hpp"
/*
 * Author: Blue
 * Define parameter object as location for reinforcement point.
 *
 * Arguments:
 * 0: Reference Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object] call ACM_evacuation_fnc_defineReinforcePoint;
 *
 * Public: No
 */

params ["_object"];

GVAR(ReinforcePoint) = _object;