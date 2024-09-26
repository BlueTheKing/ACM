#include "..\script_component.hpp"
/*
 * Author: SzwedzikPL
 * Shows dog tag.
 *
 * Arguments:
 * 0: Dog tag data <ARRAY>
 * 1: Display as double tag <BOOLEAN>
 *
 * Return Value:
 * None
 *
 * Example:
 * [["name", "610-27-5955", "A+", "85 KG"], true] call ace_dogtags_fnc_showDogtag
 *
 * Public: No
 */

disableSerialization;

params ["_dogtagData", ["_doubleTags", false, [false]]];

if (!hasInterface || {_dogtagData isEqualTo []}) exitWith {};

if (_doubleTags) then {
    (QACEGVAR(dogtags,tag) call BIS_fnc_rscLayer) cutRsc [QGVAR(doubleTag), "PLAIN", 1, true];
} else {
    (QACEGVAR(dogtags,tag) call BIS_fnc_rscLayer) cutRsc [QGVAR(singleTag), "PLAIN", 1, true];
};

private _display = uiNamespace getVariable [QACEGVAR(dogtags,tag), displayNull];

if (isNull _display) exitWith {};

private _control = _display displayCtrl 1001;
_dogtagData params ["_name", "_code", "_bloodType", "_weight"];

// If data doesn't exist or body has no name, set name as "unknown"
if (_name == "") then {
    _name = ACELLSTRING(common,unknown);
};

if (count _name > 21) then {
    _name = _name select [0, 20];
};

_control ctrlSetStructuredText parseText format ["%1<br/>%2<br/>%3<br/>%4", toUpper _name, _code, _bloodType, _weight];
