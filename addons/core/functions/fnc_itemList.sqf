#include "..\script_component.hpp"
/*
 * Author: Miss Heda
 * Classnames of the items a unit can use. Without an inventory mod this is
 * ace_common_fnc_uniqueItems; with Enhanced First Aid Kits it also lists what is packed in the
 * unit's kits.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Include magazines, as ace_common_fnc_uniqueItems: 0 no, 1 yes, 2 only magazines <NUMBER> (default: 0)
 *
 * Return Value:
 * Classnames <ARRAY>
 *
 * Example:
 * [player, 0] call ACM_core_fnc_itemList;
 *
 * Public: Yes
 */

params [["_unit", objNull, [objNull]], ["_mode", 0, [0]]];

if (isNull _unit) exitWith {[]};

if (!isNil "efak_medical_fnc_listItems") exitWith {
    // In the config's own spelling, so the "in" checks that use this list match whatever case the
    // inventory mod keeps its contents in.
    ([_unit, _mode] call efak_medical_fnc_listItems) apply {
        private _config = configFile >> "CfgWeapons" >> _x;
        if !(isClass _config) then {_config = configFile >> "CfgMagazines" >> _x};
        [_x, configName _config] select (isClass _config)
    }
};

[_unit, _mode] call ACEFUNC(common,uniqueItems)
