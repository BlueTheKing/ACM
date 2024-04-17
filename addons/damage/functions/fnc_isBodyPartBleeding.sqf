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
 * Body part is bleeding <BOOL>
 *
 * Example:
 * [cursorTarget, "head"] call ACM_damage_fnc_isBodyPartBleeding;
 *
 * Public: No
 */

params ["_patient", "_bodyPart"];

[_patient, "head"] call FUNC(getBodyPartBleeding) > 0;