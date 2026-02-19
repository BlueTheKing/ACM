#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if player has incompatible addons loaded.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_core_fnc_checkIncompatibleAddons;
 *
 * Public: No
 */

if !(hasInterface) exitWith {};

private _count = 0;
private _addonText = "";
{
    _x params ["_addon","_name"];

    if ([_addon] call ACEFUNC(common,isModLoaded)) then {
        _count = _count + 1;
        if (_count > 1) then {
            _addonText = format ["%1, %2", _addonText, _name];
        } else {
            _addonText = _name;
        };
    };
} forEach ACM_INCOMPATIBLE_ADDONS;

private _text = format ["%1 %2", LLSTRING(IncompatibleAddons_Found), _addonText];

if (_count > 0) then {
    ["[ACM] ERROR", (composeText [parseText format ["<t align='center'>%1</t>", _text]]), {findDisplay 46 closeDisplay 0}] call ACEFUNC(common,errorMessage);
    ERROR_1("INCOMPATIBLE ADDONS FOUND: %1",_addonText);
};