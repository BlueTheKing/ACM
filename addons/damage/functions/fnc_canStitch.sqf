#include "..\script_component.hpp"
/*
 * Author: Katalam, mharis001, Brett Mayson
 * Checks if the patient's body part can be stitched.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Wound Type <NUMBER>
 * 4: Use Suture? <BOOL>
 *
 * ReturnValue:
 * Can Stitch <BOOL>
 *
 * Example:
 * [player, cursorTarget, "head", 0, false] call ace_medical_treatment_fnc_canStitch; // ACM_damage_fnc_canStitch;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", ["_type", 0], ["_useSuture", false]];

if ((ACEGVAR(medical_treatment,consumeSurgicalKit) == 2) && {!([_medic, _patient, ["ACE_suture"]] call ACEFUNC(medical_treatment,hasItem))}) exitWith {false};

if (_useSuture && ((ACEGVAR(medical_treatment,consumeSurgicalKit) == 2) || {!([_medic, _patient, ["ACE_suture"]] call ACEFUNC(medical_treatment,hasItem))})) exitWith {false};

(!([_patient, _bodyPart] call FUNC(isBodyPartBleeding)) && {
    switch (_type) do {
        case 1: {(GET_WRAPPED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) isNotEqualTo []};
        case 2: {(GET_CLOTTED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) isNotEqualTo []};
        default {(GET_BANDAGED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) isNotEqualTo []};
    };
})