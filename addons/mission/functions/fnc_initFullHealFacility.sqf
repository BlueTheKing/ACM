#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init interactions for full heal facility.
 *
 * Arguments:
 * 0: Tent Object <OBJECT>
 * 1: Interaction Distance <NUMBER>
 * 2: Interaction Position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [this, 5, [0,0,0]] call ACM_mission_fnc_initFullHealFacility;
 *
 * Public: No
 */

params ["_object", ["_distance", 5], ["_position", [0,0,0]]];

private _actions = [];
_actions pushBack (["ACM_Mission_FullHealFacility",
LLSTRING(FullHealFacility_Action),
"",
{
    params ["_object", "_unit"];

    private _targetUnits = _object nearEntities ["Man", 5.5];

    {
        if (_x getVariable [QEGVAR(evacuation,casualtyTicketClaimed), false]) exitWith {};
        [QACEGVAR(medical_treatment,fullHealLocal), [_x], _x] call CBA_fnc_targetEvent;
    } forEach _targetUnits;
},
{true},
{
    params ["_object", "_unit"];

    private _targetUnits = _object nearEntities ["Man", 5.5];

    private _actions = [];

    {
        if ((_x != _unit) && !(_x getVariable [QEGVAR(evacuation,casualtyTicketClaimed), false])) then {
            _actions pushBack ([[format ["ACM_Mission_FullHealFacility_%1", [_x, false, true] call ACEFUNC(common,getName)],
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
            ] call ACEFUNC(interact_menu,createAction), [], (_this select 1)]);
        };
    } forEach _targetUnits;

    _actions;
}, [], _position, _distance] call ACEFUNC(interact_menu,createAction));

{
    [_object, 0, [], _x] call ACEFUNC(interact_menu,addActionToObject);
} forEach _actions;