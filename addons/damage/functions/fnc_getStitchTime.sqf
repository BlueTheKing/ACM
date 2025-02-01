#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get time required to stitch depending on type of wound.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Wound Type <NUMBER>
 * 3: Use Suture? <BOOL>
 * 4: Single Wound? <BOOL>
 *
 * Return Value:
 * Treatment Time <NUMBER>
 *
 * Example:
 * [cursorObject, "head", 0, false, false] call ACM_damage_fnc_getStitchTime;
 *
 * Public: No
 */

params ["_patient", "_bodyPart", ["_woundType", 0], ["_useSuture", false], ["_single", false]];

private _multiplier = [1, EGVAR(core,treatmentTimeSutureStitch)] select _useSuture;

private _stitchTime = 1;

if (_single) then {
    _stitchTime = [ACEGVAR(medical_treatment,woundStitchTime), EGVAR(core,treatmentTimeWrappedStitch), ACEGVAR(medical_treatment,woundStitchTime)] select _woundType;
} else {
    _stitchTime = [(count (GET_BANDAGED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) * ACEGVAR(medical_treatment,woundStitchTime)),
    (count (GET_WRAPPED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) * EGVAR(core,treatmentTimeWrappedStitch)),
    (count (GET_CLOTTED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) * ACEGVAR(medical_treatment,woundStitchTime))] select _woundType;
};

_stitchTime * _multiplier;