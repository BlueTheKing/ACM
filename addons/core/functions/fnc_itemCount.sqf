#include "..\script_component.hpp"
/*
 * Author: Miss Heda
 * How many of an item a unit can use. Without an inventory mod this is ace_common_fnc_getCountOfItem;
 * with Enhanced First Aid Kits it also counts what is packed in the unit's kits.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item classname <STRING>
 *
 * Return Value:
 * Count <NUMBER>
 *
 * Example:
 * [player, "ACM_Syringe_10"] call ACM_core_fnc_itemCount;
 *
 * Public: Yes
 */

params [["_unit", objNull, [objNull]], ["_item", "", [""]]];

if (isNull _unit || {_item isEqualTo ""}) exitWith {0};

if (!isNil "efak_medical_fnc_countItem") exitWith {
    [_unit, _item] call efak_medical_fnc_countItem
};

[_unit, _item] call ACEFUNC(common,getCountOfItem)
