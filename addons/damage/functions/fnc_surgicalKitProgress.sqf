#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut, mharis001
 * Handles the surgical kit treatment by periodically closing bandaged wounds.
 *
 * Arguments:
 * 0: Arguments <ARRAY>
 *   0: Medic (not used) <OBJECT>
 *   1: Patient <OBJECT>
 *   2: Body Part <STRING>
 * 1: Elapsed Time <NUMBER>
 * 2: Total Time <NUMBER>
 * 3: Wound Type <NUMBER>
 * 4: Use Suture? <BOOL>
 *
 * Return Value:
 * Continue Treatment <BOOL>
 *
 * Example:
 * [[objNull, player], 5, 10, 0, false] call ace_medical_treatment_fnc_surgicalKitProgress // ACM_damage_fnc_surgicalKitProgress;
 *
 * Public: No
 */

params ["_args", "_elapsedTime", "_totalTime", ["_woundType", 0], ["_useSuture", false]];
_args params ["_medic", "_patient", "_bodyPart"];

private _targetWounds = [GET_BANDAGED_WOUNDS(_patient), GET_WRAPPED_WOUNDS(_patient), GET_CLOTTED_WOUNDS(_patient)] select _woundType;
private _targetWoundsOnPart = _targetWounds getOrDefault [_bodyPart, []];

// Stop treatment if there are no wounds that can be stitched remaining
if (_targetWoundsOnPart isEqualTo []) exitWith {false};

// Not enough time has elapsed to stitch a wound
if (_totalTime - _elapsedTime > ([_patient, _bodyPart, _woundType, _useSuture] call FUNC(getStitchTime)) - ([_patient, _bodyPart, _woundType, _useSuture, true] call FUNC(getStitchTime))) exitWith {true};

// Stitch the first possible wound on the body part
private _stitched = [_patient, _bodyPart, [], _woundType] call FUNC(stitchWound);

if (!_stitched) exitWith {
    ERROR_1("failed to stitch wound on unit - %1",_patient);
    false
};

// Consume a suture for the next wound if one exists, stop stitching if none are left
if ((ACEGVAR(medical_treatment,consumeSurgicalKit) == 2 || _useSuture) && {_targetWoundsOnPart isNotEqualTo []}) then {
    ([_medic, _patient, ["ACE_suture"]] call ACEFUNC(medical_treatment,useItem)) params ["_user"];
    !isNull _user;
} else {
    true;  
};