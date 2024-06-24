#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return ACE actions for filled syringes.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Is IV? <BOOL>
 *
 * Return Value:
 * ACE actions <ARRAY>
 *
 * Example:
 * [player, false] call ACM_circulation_fnc_Syringe_Draw_ChildActions;
 *
 * Public: No
 */

params ["_unit", ["_IV", false]];

private _sourceString = ["IM","IV"] select _IV;

private _targetItems = [];

private _containers = [uniformContainer _unit, vestContainer _unit, backpackContainer _unit];

if (_IV) then {
    {
        _targetItems append ((magazinesAmmoCargo _x) select {(_x select 0) in ACM_SYRINGES_IV});       
    } forEach _containers;
} else {
    {
        _targetItems append ((magazinesAmmoCargo _x) select {(_x select 0) in ACM_SYRINGES_IM});       
    } forEach _containers;
};

private _actions = [];

{
    _x params ["_classname", "_dose"];

    private _medicationName = (_classname splitString "_") select 3;
    private _actionString = format ["ACM_Action_Syringe_%1_%2_%3", _sourceString, _medicationName, _dose];

    _actions pushBack [[_actionString,
    (format ["%1 (%2ml)", _medicationName, ((_dose / 100) toFixed 1)]),
    "",
    {},
    {true},
    {
        params ["", "_unit", "_args"];
        _args params ["_actionString", "_medication", "_IV", "_dose"];

        private _action = [([[format ["%1_Discard", _actionString],
        "Discard",
        "",
        {
            params ["", "", "_args"];
            _args params ["_unit", "_medication", "_IV", "_dose"];

            [_unit, _medication, _IV, _dose] call FUNC(Syringe_Discard);
        },{true},{},[_unit, _medication, _IV, _dose]] call ACEFUNC(interact_menu,createAction),[],(_this select 1)])];

        _action;
    },
    [_actionString, _medicationName, _IV, _dose]] call ACEFUNC(interact_menu,createAction),[],(_this select 1)];
} forEach _targetItems;

_actions;