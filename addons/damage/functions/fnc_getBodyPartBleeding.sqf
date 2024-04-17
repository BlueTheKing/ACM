#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get bleeding amount of body part
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 *
 * Return Value:
 * Amount of bleeding on body part <NUMBER>
 *
 * Example:
 * [cursorTarget, "head"] call ACM_damage_fnc_getBodyPartBleeding;
 *
 * Public: No
 */

params ["_patient", "_bodyPart"];

//ace_medical_treatment_fnc_canStitch
private _bleedingAmount = 0;
{
    _x params ["", "_amountOf", "_bleedingRate"];

    if (_amountOf > 0 && {_bleedingRate > 0}) then {
        _bleedingAmount = _bleedingAmount + _amountOf * _bleedingRate;
    };
} forEach (GET_OPEN_WOUNDS(_patient) get _bodyPart);

_bleedingAmount;