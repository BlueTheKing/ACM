#include "..\script_component.hpp"
/*
 * Author: Blue
 * Wrap bruises on body part
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Wrap Remaining <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "head", 8] call ACM_damage_fnc_wrapBruisesLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", ["_wrapRemaining", 8]];

private _woundsOnPart = GET_OPEN_WOUNDS(_patient) getOrDefault [_bodyPart, []];

if (_woundsOnPart isEqualTo []) exitWith {};

private _highestID = -1;
private _woundIndex = -1;
private _woundAmount = -1;

{
    _x params ["_id", "_amountOf"];

    if (((_wrapRemaining >= 4 && _id isEqualTo 22) || (_wrapRemaining >= 2 && _id isEqualTo 21) || (_wrapRemaining > 0 && _id isEqualTo 20)) && {_amountOf > 0} && {_id > _highestID}) then {
        _highestID = _id;
        _woundIndex = _forEachIndex;
        _woundAmount = _amountOf;
    };
} forEach _woundsOnPart;

if (_highestID isEqualTo -1) exitWith {};

private _bruiseEntry = _woundsOnPart select _woundIndex;
_bruiseEntry params ["_bruiseID", "_bruiseCount", "", "_bruiseDamage"];

private _bruiseSeverity = 1;

switch (_highestID) do {
    case 22: {_bruiseSeverity = 4}; // large
    case 21: {_bruiseSeverity = 2}; // medium
    default {}; // small
};

private _amountLeft = _bruiseCount - _wrapRemaining / _bruiseSeverity;
private _amountTreated = ((_amountLeft max 0) - _bruiseCount) * -1;

private _treatedBruise = [_bruiseID, _bruiseCount, 0, _bruiseDamage];

if (_amountLeft > 0) then {
    _wrapRemaining = 0;
    _treatedBruise set [1, _amountLeft];
    _woundsOnPart set [_woundIndex, _treatedBruise];
} else { // Get rid of bruise if it's fully treated
    _wrapRemaining = _wrapRemaining - _bruiseCount * _bruiseSeverity;
    _woundsOnPart deleteAt _woundIndex;
};

private _partIndex = ALL_BODY_PARTS find _bodyPart;
private _bodyPartDamage = _patient getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]];
private _damage = (_bodyPartDamage select _partIndex) - _bruiseDamage * _amountTreated;

if (_damage > 0.05) then {
    _bodyPartDamage set [_partIndex, _damage];
} else {
    _bodyPartDamage set [_partIndex, 0];
};

_patient setVariable [QACEGVAR(medical,bodyPartDamage), _bodyPartDamage, true];

private _wounds = GET_OPEN_WOUNDS(_patient);
_wounds set [_bodyPart, _woundsOnPart];

if (_wrapRemaining > 0) then { // If some wrap remains try to treat more bruises
    [_medic, _patient, _bodyPart, _wrapRemaining] call FUNC(wrapBruisesLocal);
};