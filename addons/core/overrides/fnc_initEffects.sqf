#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Initializes visual effects of medical.
 *
 * Arguments:
 * 0: Update pain and low blood volume effects only <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [false] call ace_medical_feedback_fnc_initEffects
 *
 * Public: No
 */

params [["_updateOnly", false]];

TRACE_1("initEffects",_updateOnly);

private _fnc_createEffect = {
    params ["_type", "_layer", "_default"];

    private _effect = ppEffectCreate [_type, _layer];
    _effect ppEffectForceInNVG true;
    _effect ppEffectAdjust _default;
    _effect ppEffectCommit 0;

    _effect
};

// - Pain ---------------------------------------------------------------------
if (!isNil QACEGVAR(medical_feedback,ppPain)) then {
    TRACE_1("delete pain",ACEGVAR(medical_feedback,ppPain));
    if (ACEGVAR(medical_feedback,ppPain) != -1) then { ppEffectDestroy ACEGVAR(medical_feedback,ppPain); };
};
switch (ACEGVAR(medical_feedback,painEffectType)) do {
    case FX_PAIN_WHITE_FLASH: {
        ACEGVAR(medical_feedback,ppPain) = [
            "ColorCorrections",
            13502,
            [1, 1, 0, [1, 1, 1, 0], [1, 1, 1, 1], [0.33, 0.33, 0.33, 0], [0.55, 0.5, 0, 0, 0, 0, 4]]
        ] call _fnc_createEffect;
    };
    case FX_PAIN_PULSATING_BLUR: {
        ACEGVAR(medical_feedback,ppPain) = [
            "RadialBlur", // "Will not do anything if RADIAL BLUR is disabled in Video Options."
            13502,
            [0, 0, 0.25, 0.25]
        ] call _fnc_createEffect;
    };
    case FX_PAIN_CHROMATIC_ABERRATION: {
        ACEGVAR(medical_feedback,ppPain) = [
            "ChromAberration",
            13502,
            [0, 0, false]
        ] call _fnc_createEffect;
    };
    default { ACEGVAR(medical_feedback,ppPain) = -1; };
};
// Base blur on high pain
if (isNil QACEGVAR(medical_feedback,ppPainBlur)) then {
    ACEGVAR(medical_feedback,ppPainBlur) = [
        "DynamicBlur",
        813, // 135xx does not work
        [0]
    ] call _fnc_createEffect;
};

TRACE_1("created pain",ACEGVAR(medical_feedback,ppPain));

// - Blood volume -------------------------------------------------------------
private _ppBloodVolumeSettings = [
    "ColorCorrections",
    13503,
    [1, 1, 0,  [0, 0, 0, 0],  [1, 1, 1, 1],  [0.2, 0.2, 0.2, 0]]
];
ACEGVAR(medical_feedback,showBloodVolumeIcon) = false;

if (!isNil QACEGVAR(medical_feedback,ppBloodVolume)) then {
    TRACE_1("delete blood volume",ACEGVAR(medical_feedback,ppBloodVolume));
    ppEffectDestroy ACEGVAR(medical_feedback,ppBloodVolume);
    ACEGVAR(medical_feedback,ppBloodVolume) = nil;
};
switch (ACEGVAR(medical_feedback,bloodVolumeEffectType)) do {
    case FX_BLOODVOLUME_COLOR_CORRECTION: {
        ACEGVAR(medical_feedback,ppBloodVolume) = _ppBloodVolumeSettings call _fnc_createEffect;
    };
    case FX_BLOODVOLUME_ICON: {
        ACEGVAR(medical_feedback,showBloodVolumeIcon) = true;
    };
    case FX_BLOODVOLUME_BOTH: {
        ACEGVAR(medical_feedback,showBloodVolumeIcon) = true;
        ACEGVAR(medical_feedback,ppBloodVolume) = _ppBloodVolumeSettings call _fnc_createEffect;
    };
};

GVAR(ppAnestheticEffect_chrom) = [
    "ChromAberration",
    13506,
    [0, 0, false]
] call _fnc_createEffect;

if (_updateOnly) exitWith {};

// - Unconscious --------------------------------------------------------------
ACEGVAR(medical_feedback,ppUnconsciousBlur) = [
    "DynamicBlur",
    814, // 135xx does not work
    [0]
] call _fnc_createEffect;

ACEGVAR(medical_feedback,ppUnconsciousBlackout) = [
    "ColorCorrections",
    13500,
    [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
] call _fnc_createEffect;

// - Incapacitation -----------------------------------------------------------
ACEGVAR(medical_feedback,ppIncapacitationGlare) = [
    "ColorCorrections",
    13504,
    [1, 1, 0, [0, 0, 0, 0], [1, 1, 1, 1], [0, 0, 0, 0]]
] call _fnc_createEffect;

ACEGVAR(medical_feedback,ppIncapacitationBlur) = [
    "DynamicBlur",
    815, // 135xx does not work
    [0]
] call _fnc_createEffect;

// - Low Oxygen Tunnels Vision ------------------------------------------------
GVAR(ppLowOxygenTunnelVision) = [
    "ColorCorrections",
    13505,
    [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 0], [0.1, 0.1, 0.1, 0.1], [0.85, 0.8, 0, 0, 0, 0, 8]]
] call _fnc_createEffect;
