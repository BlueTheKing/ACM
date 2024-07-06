#include "..\script_component.hpp"
/*
 * Author: esteldunedain
 * Get unit dogtag data.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Return Value:
 * Dogtag Data <ARRAY>
 * 0: Name <STRING>
 * 1: SSN <STRING>
 * 2: Blood Type <STRING>
 *
 * Example:
 * _dogtagData = [player] call ace_dogtags_fnc_getDogtagData
 *
 * Public: No
 */

params ["_target"];

// Check if the data was already created
private _dogTagData = _target getVariable QACEGVAR(dogtags,dogtagData);
if (!isNil "_dogTagData") exitWith {_dogTagData};

// Create dog tag data once for the unit: nickname, code (eg. 135-13-900) and blood type
private _targetName = [_target, false, true] call ACEFUNC(common,getName);
private _bloodType = GET_BLOODTYPE(_target);
private _weight = "";

if (_bloodType == -1) then {
    _bloodType = [_target] call EFUNC(circulation,generateBloodType);
};

if (GVAR(Dogtag_ShowWeight)) then {
    _weight = format ["%1 KG", round GET_BODYWEIGHT(_target)];
};

private _dogTagData = [
    _targetName,
    _targetName call ACEFUNC(dogtags,ssn),
    ([_bloodType, 1] call EFUNC(circulation,convertBloodType)),
    _weight
];
// Store it
_target setVariable [QACEGVAR(dogtags,dogtagData), _dogTagData, true];
_dogTagData
