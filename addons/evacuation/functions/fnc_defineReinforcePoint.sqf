#include "..\script_component.hpp"
/*
 * Author: Blue
 * Define parameter object as location for reinforcement point.
 *
 * Arguments:
 * 0: Reference Object <OBJECT>
 * 1: Side <NUMBER>
 *   0: BLUFOR
 *   1: REDFOR
 *   2: GREENFOR
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object, _side] call ACM_evacuation_fnc_defineReinforcePoint;
 *
 * Public: No
 */

params ["_object", ["_side", 0]];

switch (_side) do {
    case 1: {
        GVAR(ReinforcePoint_REDFOR) = _object;
    };
    case 2: {
        GVAR(ReinforcePoint_GREENFOR) = _object;
    };
    default {
        GVAR(ReinforcePoint_BLUFOR) = _object;
    };
};