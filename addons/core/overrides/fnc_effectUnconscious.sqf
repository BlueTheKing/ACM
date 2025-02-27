#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Handles the unconscious effect.
 *
 * Arguments:
 * 0: Enable <BOOL>
 * 1: Mode (0: instant, 1: animation, 2: fx handler) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true, 0] call ace_medical_feedback_fnc_effectUnconscious
 *
 * Public: No
 */

params ["_enable", "_mode"];

switch (_mode) do {
    // Instant (for Zeus or death)
    case 0: {
        ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectEnable _enable;
        ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectEnable _enable;
    };
    // Animated (triggered on unconscious event)
    case 1: {
        if (_enable) then {
            private _oxygenDeprivation = GET_OXYGEN(ACE_player) < ACM_OXYGEN_UNCONSCIOUS;
            private _fadeInTime = [FX_UNCON_FADE_IN, 0.5] select _oxygenDeprivation;
            
            ACE_player setVariable [QACEGVAR(medical_feedback,effectUnconsciousTimeout), CBA_missionTime + _fadeInTime];
            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectEnable true;
            ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectEnable true;

            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectAdjust [0];
            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectCommit 0;
            
            if (_oxygenDeprivation) then {
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0.25, 0.2, 0, 0, 0, 0, 1]];
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit 0;

                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
            } else {
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit 0;

                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
            };
            
            ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit _fadeInTime;
            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectAdjust [5];
            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectCommit _fadeInTime;
            
            // Handle next fade in
            ACEGVAR(medical_feedback,nextFadeIn) = CBA_missionTime + 15 + random 5;
        } else {
            ACE_player setVariable [QACEGVAR(medical_feedback,effectUnconsciousTimeout), CBA_missionTime + FX_UNCON_FADE_OUT];
            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectEnable true;
            ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectEnable true;

            // Step 1: Widen eye "hole"
            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectAdjust [5];
            ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0.9], [0, 0, 0, 1], [0, 0, 0, 0], [0.51, 0.17, 0, 0, 0, 0, 1]];
            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectCommit (FX_UNCON_FADE_OUT * 1/3);
            ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit (FX_UNCON_FADE_OUT * 1/3);

            // Step 2: Open it
            [{
                if (!isNull curatorCamera || {!alive ACE_player}) exitWith {};

                ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectAdjust [0];
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0.8], [0, 0, 0, 1], [0, 0, 0, 0], [0.7, 0.78, 0, 0, 0, 0, 1]];
                ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectCommit (FX_UNCON_FADE_OUT * 2/3);
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit (FX_UNCON_FADE_OUT * 1/3);
            }, [], FX_UNCON_FADE_OUT * 1/3] call CBA_fnc_waitAndExecute;

            // Step 3: Fade away vignette
            [{
                if (!isNull curatorCamera || {!alive ACE_player}) exitWith {};

                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0], [0.7, 0.78, 0, 0, 0, 0, 1]];
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit (FX_UNCON_FADE_OUT * 1/3);
            }, [], FX_UNCON_FADE_OUT * 2/3] call CBA_fnc_waitAndExecute;
        };
    };
    // Raised by effectsHandler (blocked if animation in progress)
    case 2: {
        private _animatedTimeOut = ACE_player getVariable [QACEGVAR(medical_feedback,effectUnconsciousTimeout), 0];
        if (_animatedTimeOut > CBA_missionTime) exitWith {};

        if (_enable) then {
            if (ACEGVAR(medical_feedback,nextFadeIn) < CBA_missionTime) then {
                ACEGVAR(medical_feedback,ppUnconsciousBlur) ppEffectAdjust [5];
                ACEGVAR(medical_feedback,ppUnconsciousBlur) ppEffectCommit 0;

                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0.9], [0, 0, 0, 1], [0, 0, 0, 0], [0.51, 0.17, 0, 0, 0, 0, 1]];
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit (FX_UNCON_FADE_OUT * 2/3);

                [{
                    if (!isNull curatorCamera || {!alive ACE_player}) exitWith {};

                    ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
                    ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit (FX_UNCON_FADE_OUT * 1/3);
                }, [], FX_UNCON_FADE_OUT * 2/3] call CBA_fnc_waitAndExecute;

                ACE_player setVariable [QACEGVAR(medical_feedback,effectUnconsciousTimeout), CBA_missionTime + FX_UNCON_FADE_OUT];
                ACEGVAR(medical_feedback,nextFadeIn) = CBA_missionTime + FX_UNCON_FADE_OUT + 15 + random 5;
            } else {
                ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectAdjust [5];
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
                ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectCommit 0;
                ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit 0;
            };
        } else {
            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectAdjust [0];
            ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
            ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectCommit 0;
            ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectCommit 0;
        };

        ACEGVAR(medical_feedback,ppUnconsciousBlur)     ppEffectEnable _enable;
        ACEGVAR(medical_feedback,ppUnconsciousBlackout) ppEffectEnable _enable;
    };
};
