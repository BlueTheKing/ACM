#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Triggers the pain effect (single flash).
 *
 * Arguments:
 * 0: Enable <BOOL>
 * 1: Intensity <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true, 0.5] call ace_medical_feedback_fnc_effectPain
 *
 * Public: No
 */

params ["_enable", "_intensity"];

if (!_enable || {_intensity == 0}) exitWith {
    if (ACEGVAR(medical_feedback,ppPain) != -1) then { ACEGVAR(medical_feedback,ppPain) ppEffectEnable false; };

    ACEGVAR(medical_feedback,ppPainBlur) ppEffectEnable false;
};

if (ACEGVAR(medical_feedback,ppPain) != -1) then { ACEGVAR(medical_feedback,ppPain) ppEffectEnable true; };
ACEGVAR(medical_feedback,ppPainBlur) ppEffectEnable true;

// Trigger effect every 2s
private _showNextTick = missionNamespace getVariable [QACEGVAR(medical_feedback,showPainNextTick), true];
ACEGVAR(medical_feedback,showPainNextTick) = !_showNextTick;
if (_showNextTick) exitWith {};

private _blurIntensity = linearConversion [0.2, 1, _intensity, 0, 2, true];
ACEGVAR(medical_feedback,ppPainBlur) ppEffectAdjust [_blurIntensity];
ACEGVAR(medical_feedback,ppPainBlur) ppEffectCommit 0.1;

if (ACEGVAR(medical_feedback,painEffectType) == FX_PAIN_ONLY_BASE) exitWith {};

private _initialAdjust = [];
private _delayedAdjust = [];

switch (ACEGVAR(medical_feedback,painEffectType)) do {
    case FX_PAIN_WHITE_FLASH: {
        _intensity     = linearConversion [0, 1, _intensity, 0.1, 0.8, true];
        _initialAdjust = [1, 1, 0, [1, 1, 1, _intensity      ], [1, 1, 1, 1], [0.33, 0.33, 0.33, 0], [0.55, 0.5, 0, 0, 0, 0, 4]];
        _delayedAdjust = [1, 1, 0, [1, 1, 1, _intensity * 0.3], [1, 1, 1, 1], [0.33, 0.33, 0.33, 0], [0.55, 0.5, 0, 0, 0, 0, 4]];
    };
    case FX_PAIN_PULSATING_BLUR: {
        _intensity     = linearConversion [0, 1, _intensity, 0, 0.008, true];
        _initialAdjust = [_intensity      , _intensity      , 0.15, 0.15];
        _delayedAdjust = [_intensity * 0.2, _intensity * 0.2, 0.25, 0.25];
    };
    case FX_PAIN_CHROMATIC_ABERRATION: {
        _intensity     = linearConversion [0, 1, _intensity, 0, 0.06, true];
        _initialAdjust = [_intensity       , _intensity       , true];
        _delayedAdjust = [_intensity * 0.15, _intensity * 0.15, true];
    };
};

ACEGVAR(medical_feedback,ppPain) ppEffectAdjust _initialAdjust;
ACEGVAR(medical_feedback,ppPain) ppEffectCommit FX_PAIN_FADE_IN;
[{
    params ["_adjust", "_painEffectType"];

    if (ACEGVAR(medical_feedback,painEffectType) != _painEffectType) exitWith {TRACE_1("Effect type changed",_this);};

    ACEGVAR(medical_feedback,ppPain) ppEffectAdjust _adjust;
    ACEGVAR(medical_feedback,ppPain) ppEffectCommit FX_PAIN_FADE_OUT;
}, [_delayedAdjust, ACEGVAR(medical_feedback,painEffectType)], FX_PAIN_FADE_IN] call CBA_fnc_waitAndExecute;
