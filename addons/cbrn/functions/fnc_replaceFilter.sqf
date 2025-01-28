#include "..\script_component.hpp"
/*
 * Author: Blue
 * Make unit replace gas mask filter.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_replaceFilter;
 *
 * Public: No
 */

params ["_unit"];

[3, [_unit], {
    params ["_args"];
    _args params ["_unit"];

    _unit removeItem "ACM_GasMaskFilter";
    _unit setVariable [QGVAR(Filter_State), 1200];

    [LLSTRING(GasMask_ReplaceFilter_Complete), 1.5, _unit] call ACEFUNC(common,displayTextStructured);
}, {}, LLSTRING(GasMask_ReplaceFilter_Progress), {true}, ["isNotInside"]] call ACEFUNC(common,progressBar);