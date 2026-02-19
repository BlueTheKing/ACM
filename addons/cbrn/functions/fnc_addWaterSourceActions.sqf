#include "..\script_component.hpp"
/*
 * Author: Blue
 * Add ace actions for water source objects.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * ACE actions <ARRAY>
 *
 * Example:
 * [] call ACM_CBRN_fnc_addWaterSourceActions;
 *
 * Public: No
 */

private _actions = [];

_actions pushBack (["ACM_Action_WashEyes",
LLSTRING(WashEyes),
"",
{
    params ["_object", "_unit"];

    [3, [_object, _unit], {
        params ["_args"];
        _args params ["_object", "_unit"];

        [_unit, _unit, "", _object] call FUNC(washEyes);
    }, {}, LLSTRING(WashEyes_Progress), {true}, ["isNotInside"]] call ACEFUNC(common,progressBar);
},
{
    params ["_object", "_unit"];

    if !([_unit] call FUNC(canWashEyes)) exitWith {false};

    private _waterSource = _object getVariable [QACEGVAR(field_rations,waterSource), objNull];
    private _waterRemaining = _waterSource call ACEFUNC(field_rations,getRemainingWater);
    _waterRemaining == -10 || _waterRemaining > 0;
}] call ACEFUNC(interact_menu,createAction));

_actions pushBack (["ACM_Action_WashEyes_Of",
LLSTRING(WashEyesOf),
"",
{},
{
    params ["_object", "_unit"];

    private _waterSource = _object getVariable [QACEGVAR(field_rations,waterSource), objNull];
    private _waterRemaining = _waterSource call ACEFUNC(field_rations,getRemainingWater);

    _waterRemaining == -10 || _waterRemaining > 0;
},
{
    params ["_object", "_unit"];

    private _targetUnits = _object nearEntities ["Man", ACEGVAR(medical_gui,maxDistance)];

    private _actions = [];

    {
        if (_x != _unit) then {
            _actions pushBack ([[format ["ACM_Action_WashEyes_Of_%1", [_x, false, true] call ACEFUNC(common,getName)],
            [_x, false, true] call ACEFUNC(common,getName),
            "",
            {
                params ["", "_unit", "_args"];
                _args params ["_target", "_object"];

                [3, [_object, _unit, _target], {
                    params ["_args"];
                    _args params ["_object", "_unit", "_target"];

                    [_unit, _target, "", _object] call FUNC(washEyes);
                }, {}, LLSTRING(WashEyes_Progress), {true}, ["isNotInside"]] call ACEFUNC(common,progressBar);
            },
            {
                params ["", "", "_args"];
                _args params ["_target", "_object"];

                [_target] call FUNC(canWashEyes);
            },
            {},
            [_x, _object]
            ] call ACEFUNC(interact_menu,createAction), [], (_this select 1)]);
        };
    } forEach _targetUnits;

    _actions;
}] call ACEFUNC(interact_menu,createAction));

_actions;