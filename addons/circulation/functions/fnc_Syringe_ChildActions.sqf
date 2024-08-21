#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return ACE actions for filled syringes.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * ACE actions <ARRAY>
 *
 * Example:
 * [player, false] call ACM_circulation_fnc_Syringe_ChildActions;
 *
 * Public: No
 */

params ["_unit"];

private _targetItems = [];

private _containers = [uniformContainer _unit, vestContainer _unit, backpackContainer _unit];

private _syringeList = (ACM_SYRINGES_10 + ACM_SYRINGES_5 + ACM_SYRINGES_3 + ACM_SYRINGES_1);

private _actions = [];

{
    _targetItems append ((magazinesAmmoCargo _x) select {(_x select 0) in _syringeList});       
} forEach _containers;

{
    _x params ["_classname", "_dose"];
    (_classname splitString "_") params ["","", "_count", "_medicationName"];

    private _size = parseNumber _count;
    private _actionString = format ["ACM_Action_Syringe_%1_%2_%3", _size, _medicationName, _dose];

    _actions pushBack [[_actionString,
    (format ["%1 (%2/%3ml) [%4]", LLSTRING(Syringe), ((_dose / 100) toFixed 1), _size, _medicationName]),
    QPATHTOF(ui\icon_syringe_10_ca.paa),
    {},
    {true},
    {
        params ["", "_unit", "_args"];
        _args params ["_actionString", "_medication", "_size", "_dose"];

        private _action = [([[format ["%1_Discard", _actionString],
        LLSTRING(Syringe_Discard),
        "",
        {
            params ["", "", "_args"];
            _args params ["_unit", "_medication", "_size", "_dose"];

            [_unit, _medication, _size, _dose] call FUNC(Syringe_Discard);
        },{true},{},[_unit, _medication, _size, _dose]] call ACEFUNC(interact_menu,createAction),[],(_this select 1)])];

        _action;
    },
    [_actionString, _medicationName, _size, _dose]] call ACEFUNC(interact_menu,createAction),[],(_this select 1)];
} forEach _targetItems;

_actions;