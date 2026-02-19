#include "..\script_component.hpp"
/*
 * Author: Blue
 * Make target/unit replace gas mask filter.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_replaceFilter;
 *
 * Public: No
 */

params ["_target", ["_unit", objNull]];

if (!(isNull _unit) && !([_target] call FUNC(canReplaceFilter))) exitWith {
    _unit call ACEFUNC(common,goKneeling);

    [3, [_target, _unit], {
        params ["_args"];
        _args params ["_target", "_unit"];

        _unit removeItem "ACM_GasMaskFilter";
        _target setVariable [QGVAR(Filter_State), DEFAULT_FILTER_CONDITION];

        [LLSTRING(GasMask_ReplaceFilter_Complete), 1.5, _unit] call ACEFUNC(common,displayTextStructured);
    }, {}, LLSTRING(GasMask_ReplaceFilter_Progress), {true}, ["isNotInside"]] call ACEFUNC(common,progressBar);
};

_target call ACEFUNC(common,goKneeling);

[3, [_target], {
    params ["_args"];
    _args params ["_target"];

    _target removeItem "ACM_GasMaskFilter";
    _target setVariable [QGVAR(Filter_State), DEFAULT_FILTER_CONDITION];

    [LLSTRING(GasMask_ReplaceFilter_Complete), 1.5, _target] call ACEFUNC(common,displayTextStructured);
}, {}, LLSTRING(GasMask_ReplaceFilter_Progress), {true}, ["isNotInside"]] call ACEFUNC(common,progressBar);