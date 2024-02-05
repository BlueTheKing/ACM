#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if body part has bleeding wounds
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "head"] call AMS_damage_fnc_isBodyPartBleeding;
 *
 * Public: No
 */

params ["_patient", "_bodyPart"];

//ace_medical_treatment_fnc_canStitch
private _isBleeding = false;
{
    _x params ["", "_amountOf", "_bleedingRate"];
    _isBleeding = _amountOf > 0 && {_bleedingRate > 0};
    if (_isBleeding) then {break};
} forEach (GET_OPEN_WOUNDS(_patient) get _bodyPart);

_isBleeding;