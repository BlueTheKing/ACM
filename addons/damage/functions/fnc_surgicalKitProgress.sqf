#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut, mharis001
 * Handles the surgical kit treatment by periodically closing wounds.
 *
 * Arguments:
 * 0: Arguments <ARRAY>
 *   0: Medic (not used) <OBJECT>
 *   1: Patient <OBJECT>
 *   2: Body Part <STRING>
 * 1: Elapsed Time <NUMBER>
 * 2: Total Time <NUMBER>
 * 3: Wound Type <NUMBER>
 *
 * Return Value:
 * Continue Treatment <BOOL>
 *
 * Example:
 * [[objNull, player, "head"], 5, 10, 0] call ace_medical_treatment_fnc_surgicalKitProgress; // ACM_damage_fnc_surgicalKitProgress;
 *
 * Public: No
 */

params ["_args", "_elapsedTime", "_totalTime", ["_woundType", 0]];
_args params ["_medic", "_patient", "_bodyPart"];

private _targetWounds = GET_BANDAGED_WOUNDS(_patient);
private _timeToStitch = ACEGVAR(medical_treatment,woundStitchTime);
private _woundVar = VAR_BANDAGED_WOUNDS;

switch (_woundType) do {
    case 1: {
        _targetWounds = GET_WRAPPED_WOUNDS(_patient);
        _timeToStitch = EGVAR(core,treatmentTimeWrappedStitch);
        _woundVar = VAR_WRAPPED_WOUNDS;
    };
    case 2: {
        _targetWounds = GET_CLOTTED_WOUNDS(_patient);
        _woundVar = VAR_CLOTTED_WOUNDS;
    };
    default {};
};

private _targetWoundsOnPart = _targetWounds get _bodyPart;

// Stop treatment if there are no wounds that can be stitched remaining
if (_targetWoundsOnPart isEqualTo []) exitWith {false};

// Not enough time has elapsed to stitch a wound
if (_totalTime - _elapsedTime > ([_patient, _bodyPart, _woundType] call FUNC(getStitchTime)) - _timeToStitch) exitWith {true};

// Remove the first stitchable wound from the bandaged wounds
private _treatedWound = _targetWoundsOnPart deleteAt (count _targetWoundsOnPart - 1);
_treatedWound params ["_treatedID", "_treatedAmountOf", "", "_treatedDamageOf"];

// Check if we need to add a new stitched wound or increase the amount of an existing one
private _stitchedWounds = GET_STITCHED_WOUNDS(_patient);
private _stitchedWoundsOnPart = _stitchedWounds getOrDefault [_bodyPart, [], true];

private _woundIndex = _stitchedWoundsOnPart findIf {
    _x params ["_classID"];
    _classID == _treatedID
};

if (_woundIndex == -1) then {
    _stitchedWoundsOnPart pushBack _treatedWound;
} else {
    private _wound = _stitchedWoundsOnPart select _woundIndex;
    _wound set [1, (_wound select 1) + _treatedAmountOf];
};

if (ACEGVAR(medical_treatment,clearTrauma) == 1) then {
    private _partIndex = ALL_BODY_PARTS find _bodyPart;
    TRACE_2("clearTrauma - clearing trauma after stitching",_bodyPart,_treatedWound);
    private _bodyPartDamage = _patient getVariable [QACEGVAR(medical,bodyPartDamage), []];
    private _damage = (_bodyPartDamage select _partIndex) - (_treatedDamageOf * _treatedAmountOf);
    if (_damage > 0.05) then {
        _bodyPartDamage set [_partIndex, _damage];
    } else {
        _bodyPartDamage set [_partIndex, 0];
    };

    _patient setVariable [QACEGVAR(medical,bodyPartDamage), _bodyPartDamage, true];
    TRACE_2("clearTrauma - healed damage",_bodyPart,_treatedDamageOf);

    switch (_bodyPart) do {
        case "head": { [_patient, true, false, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
        case "body": { [_patient, false, true, false, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
        case "leftarm";
        case "rightarm": { [_patient, false, false, true, false] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
        default { [_patient, false, false, false, true] call ACEFUNC(medical_engine,updateBodyPartVisuals); };
    };
};

_patient setVariable [_woundVar, _targetWounds, true];
_patient setVariable [VAR_STITCHED_WOUNDS, _stitchedWounds, true];

// Check if we fixed limping by stitching this wound (only for leg wounds)
if (
    ACEGVAR(medical,limping) == 2
    && {_patient getVariable [QACEGVAR(medical,isLimping), false]}
    && {_bodyPart in ["leftleg", "rightleg"]}
) then {
    TRACE_3("Updating damage effects",_patient,_bodyPart,local _patient);
    [QACEGVAR(medical_engine,updateDamageEffects), _patient, _patient] call CBA_fnc_targetEvent;
};

// Consume a suture for the next wound if one exists, stop stitching if none are left
if (ACEGVAR(medical_treatment,consumeSurgicalKit) == 2 && {_targetWoundsOnPart isNotEqualTo []}) then {
    ([_medic, _patient, ["ACE_suture"]] call ACEFUNC(medical_treatment,useItem)) params ["_user"];
    !isNull _user
} else {
    true
}
