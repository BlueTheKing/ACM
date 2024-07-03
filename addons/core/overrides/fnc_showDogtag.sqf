#include "..\script_component.hpp"
/*
 * Author: SzwedzikPL
 * Shows dogtag.
 *
 * Arguments:
 * 0: Dogtag data <ARRAY>
 * 1: Display as double tag <BOOLEAN>
 *
 * Return Value:
 * None
 *
 * Example:
 * [["name", "610-27-5955", "A POS"], true] call ace_dogtags_fnc_showDogtag
 *
 * Public: No
 */

disableSerialization;

params ["_dogtagData", ["_doubleTags", false, [false]]];

if (!hasInterface || {_dogtagData isEqualTo []}) exitWith {};

if (_doubleTags) then {
    (QACEGVAR(dogtags,tag) call BIS_fnc_rscLayer) cutRsc [QACEGVAR(dogtags,doubleTag), "PLAIN", 1, true];
} else {
    (QACEGVAR(dogtags,tag) call BIS_fnc_rscLayer) cutRsc [QACEGVAR(dogtags,singleTag), "PLAIN", 1, true];
};
private _display = uiNamespace getvariable [QACEGVAR(dogtags,tag), displayNull];
if(isNull _display) exitWith {};

private _control = _display displayCtrl 1001;
_dogtagData params ["_nickName", "_code", "_bloodType", "_weight"];
_control ctrlSetStructuredText parseText format ["%1<br/>%2<br/>%3<br/>%4", toUpper _nickName, _code, _bloodType, _weight];
