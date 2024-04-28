#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get time required to stitch depending on type of wound.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Wound Type <NUMBER>
 *
 * Return Value:
 * Treatment Time <NUMBER>
 *
 * Example:
 * [cursorObject, "head", 0] call ACM_damage_fnc_getStitchTime;
 *
 * Public: No
 */

params ["_patient", "_bodyPart", ["_type", 0]];

switch (_type) do {
    case 1: {count (GET_WRAPPED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) * EGVAR(core,treatmentTimeWrappedStitch);};
    case 2: {count (GET_CLOTTED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) * ACEGVAR(medical_treatment,woundStitchTime);};
    default {count (GET_BANDAGED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) * ACEGVAR(medical_treatment,woundStitchTime);};
};
