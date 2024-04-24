#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init interactions for spawning patient
 *
 * Arguments:
 * 0: Tent Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [this] call ACM_mission_fnc_initHealTent;
 *
 * Public: No
 */

params ["_object"];

private _action = ["ACM_Training_HealTent",
"Full Heal",
"",
{
    params ["_object", "_unit"];

    private _targetUnits = _object nearEntities ["Man", 5.5];

    {
        [QACEGVAR(medical_treatment,fullHealLocal), [_x], _x] call CBA_fnc_targetEvent;
    } forEach _targetUnits;
},
{true},
{
    params ["_object", "_unit"];

    private _targetUnits = _object nearEntities ["Man", 5.5];

    private _actions = [];

    {
        if (_x != _unit) then {
            _actions pushBack [[format ["ACM_Training_HealTent_%1", [_x, false, true] call ACEFUNC(common,getName)],
            [_x, false, true] call ACEFUNC(common,getName),
            "",
            {
                params ["", "", "_args"];
                _args params ["_target"];

                [QACEGVAR(medical_treatment,fullHealLocal), [_target], _target] call CBA_fnc_targetEvent;
            },
            {true},
            {},
            [_x]
            ] call ACEFUNC(interact_menu,createAction), [], (_this select 1)];
        };
    } forEach _targetUnits;
},
[]
] call ACEFUNC(interact_menu,createAction);

[_object, 0, ["ACE_MainActions"], _action] call ACEFUNC(interact_menu,addActionToObject);

