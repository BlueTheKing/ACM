#include "..\script_component.hpp"
/*
 * Author: Miss Heda
 * Takes one of an item from a unit. Without an inventory mod this is removeItem (or removeMagazine
 * for a magazine); with Enhanced First Aid Kits a loose item goes first and one packed in a kit
 * after it.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item classname <STRING>
 *
 * Return Value:
 * Taken <BOOL>
 *
 * Example:
 * [player, "ACM_Syringe_10"] call ACM_core_fnc_itemTake;
 *
 * Public: Yes
 */

params [["_unit", objNull, [objNull]], ["_item", "", [""]]];

if (isNull _unit || {_item isEqualTo ""}) exitWith {false};

if (!isNil "efak_medical_fnc_takeItem") exitWith {
    [_unit, _item] call efak_medical_fnc_takeItem
};

if (([_unit, _item] call ACEFUNC(common,getCountOfItem)) < 1) exitWith {false};

if (isClass (configFile >> "CfgMagazines" >> _item)) then {
    _unit removeMagazine _item;
} else {
    _unit removeItem _item;
};

true
