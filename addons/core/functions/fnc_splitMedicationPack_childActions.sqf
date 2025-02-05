#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return ACE actions for splitting medication packages.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * ACE actions <ARRAY>
 *
 * Example:
 * [player] call ACM_core_fnc_splitMedicationPack_childActions;
 *
 * Public: No
 */

params ["_unit"];

private _targetItems = [];

private _containers = [uniformContainer _unit, vestContainer _unit, backpackContainer _unit];

private _actions = [];
{
    _targetItems append ((magazinesAmmoCargo _x) select {(_x select 0) in ["ACM_Paracetamol"]});       
} forEach _containers;

{
    _x params ["_classname", "_remainingAmount"];
    (_classname splitString "_") params ["", "_item"];

    private _maxSize = 10;
    private _actionString = format ["ACM_Action_SplitMedicationPack_%1_%2", _item, (_forEachIndex + 1)];

    _actions pushBack [[_actionString,
    (format ["%1 (%2/%3)", LELSTRING(circulation,Paracetamol), _remainingAmount, _maxSize]),
    QPATHTOEF(circulation,ui\paracetamol_ca.paa),
    {},
    {true},
    {
        params ["", "_unit", "_args"];
        _args params ["_actionString", "_classname", "_remainingAmount"];
        
        private _actions = [];

        _actions pushBack [
            [
            "ACM_Action_SplitMedicationPack_Split2",
            (format ["%1 (2)", LLSTRING(SplitMedicationPack_Split)]),
            "",
            {
                params ["", "", "_args"];
                _args params ["_unit", "_classname", "_remainingAmount"];

                [_unit, _classname, _remainingAmount, 2] call FUNC(splitMedicationPack);
            },
            {
                params ["", "", "_args"];
                _args params ["_unit", "_classname", "_remainingAmount"];

                _remainingAmount > 2;
            },
            {},
            [_unit, _classname, _remainingAmount]
            ] call ACEFUNC(interact_menu,createAction),
            [],
            _unit
        ];

        _actions pushBack [
            [
            "ACM_Action_SplitMedicationPack_Split1",
            (format ["%1 (1)", LLSTRING(SplitMedicationPack_Split)]),
            "",
            {
                params ["", "", "_args"];
                _args params ["_unit", "_classname", "_remainingAmount"];

                [_unit, _classname, _remainingAmount, 1] call FUNC(splitMedicationPack);
            },
            {
                params ["", "", "_args"];
                _args params ["_unit", "_classname", "_remainingAmount"];

                _remainingAmount > 1;
            },
            {},
            [_unit, _classname, _remainingAmount]
            ] call ACEFUNC(interact_menu,createAction),
            [],
            _unit
        ];

        _actions;
    },
    [_actionString, _classname, _remainingAmount]] call ACEFUNC(interact_menu,createAction),[],_unit];
} forEach _targetItems;

_actions;