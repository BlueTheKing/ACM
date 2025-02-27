#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle splitting medication package.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item Classname <STRING>
 * 2: Current Amount <NUMBER>
 * 3: Split Size <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "ACM_Paracetamol", 10, 2] call ACM_core_fnc_splitMedicationPack;
 *
 * Public: No
 */

params ["_unit", "_classname", "_currentAmount", "_splitSize"];

private _success = [_unit, _classname, _currentAmount] call ACEFUNC(common,removeSpecificMagazine);

if !(_success) exitWith {};

private _newItem = switch (_splitSize) do {
    case 2: {
        format ["%1_DoublePack", _classname];
    };
    default {
        format ["%1_SinglePack", _classname];
    };
};
format ["%1_%2", _classname, _splitSize];

[_unit, _classname, "", (_currentAmount - _splitSize)] call ACEFUNC(common,addToInventory);
[_unit, _newItem, ""] call ACEFUNC(common,addToInventory);

[(format [LLSTRING(SplitMedicationPack_Complete), ((_classname splitString "_") select 1)]), 2, _unit] call ACEFUNC(common,displayTextStructured);