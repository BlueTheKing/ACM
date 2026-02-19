#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut, mharis001, LinkIsGrim
 * Stitches a wound (either the first or a specific wound) from a body part.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Wound Array, will close first wound on body part if empty <ARRAY> (default: [])
 * 3: Wound Type <NUMBER>
 *
 * Return Value:
 * Wound was stitched <BOOL>
 *
 * Example:
 * [player, "head", 0] call ace_medical_treatment_fnc_stitchWound // ACM_damage_fnc_stitchWound;
 *
 * Public: No
 */

params ["_patient", "_bodyPart", ["_treatedWound", []], ["_woundType", 0]];

private _stitchTimeMultiplier = [1, EGVAR(core,treatmentTimeSutureStitch)] select _useSuture;

private _targetWounds = GET_BANDAGED_WOUNDS(_patient);
private _timeToStitch = ACEGVAR(medical_treatment,woundStitchTime) * _stitchTimeMultiplier;
private _woundVar = VAR_BANDAGED_WOUNDS;

switch (_woundType) do {
    case 1: {
        _targetWounds = GET_WRAPPED_WOUNDS(_patient);
        _timeToStitch = EGVAR(core,treatmentTimeWrappedStitch) * _stitchTimeMultiplier;
        _woundVar = VAR_WRAPPED_WOUNDS;
    };
    case 2: {
        _targetWounds = GET_CLOTTED_WOUNDS(_patient);
        _woundVar = VAR_CLOTTED_WOUNDS;
    };
    default {};
};

private _targetWoundsOnPart = _targetWounds getOrDefault [_bodyPart, []];

// Get the first stitchable wound, or make sure the passed wound exists
private _targetIndex = (count _targetWoundsOnPart) - 1;
if (_treatedWound isEqualTo []) then {
    _treatedWound = _targetWoundsOnPart param [_targetIndex, _treatedWound];
} else {
    _targetIndex = _targetWoundsOnPart find _treatedWound;
};

// Wound doesn't exist or there are no wounds to stitch
if (_targetIndex == -1) exitWith {false};

// Remove the wound from bandagedWounds
_targetWoundsOnPart deleteAt _targetIndex;

_treatedWound params ["_treatedID", "_treatedAmountOf", "", "_treatedDamageOf"];

// Check if we need to add a new stitched wound or increase the amount of an existing one
private _stitchedWounds = GET_STITCHED_WOUNDS(_patient);
private _stitchedWoundsOnPart = _stitchedWounds getOrDefault [_bodyPart, [], true];

private _stitchedIndex = _stitchedWoundsOnPart findIf {
    _x params ["_classID"];
    _classID == _treatedID
};

if (_stitchedIndex == -1) then {
    _stitchedWoundsOnPart pushBack _treatedWound;
} else {
    private _wound = _stitchedWoundsOnPart select _stitchedIndex;
    _wound set [1, (_wound select 1) + _treatedAmountOf];
};

if (ACEGVAR(medical_treatment,clearTrauma) == 1) then {
    TRACE_2("trauma - clearing trauma after stitching",_bodyPart,_treatedWound);
    [_patient, _bodyPart, -(_treatedDamageOf * _treatedAmountOf)] call ACEFUNC(medical_treatment,addTrauma);
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

true // return
