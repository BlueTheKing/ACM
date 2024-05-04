#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get internal bleeding amount of body part
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part Index <NUMBER>
 *
 * Return Value:
 * Amount of bleeding on body part <NUMBER>
 *
 * Example:
 * [cursorTarget, 0] call ACM_damage_fnc_getBodyPartInternalBleeding;
 *
 * Public: No
 */

params ["_patient", "_partIndex"];

private _bodyPart = ALL_BODY_PARTS select _partIndex;

//ace_medical_treatment_fnc_canStitch
private _bleedingAmount = 0;
{
    _x params ["", "_woundCount", "_bleedingRate"];

    if (_woundCount > 0 && {_bleedingRate > 0}) then {
        _bleedingAmount = _bleedingAmount + _woundCount * _bleedingRate;
    };
} forEach (GET_INTERNAL_WOUNDS(_patient) get _bodyPart);

_bleedingAmount;