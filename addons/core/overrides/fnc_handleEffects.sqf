#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Handles any visual effects of medical.
 * Note: Heart beat sounds run in a different PFH - see fnc_effectHeartBeat.
 *
 * Arguments:
 * 0: Manual, instant update (optional, default false) <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ace_medical_feedback_fnc_handleEffects
 *
 * Public: No
 */
params [["_manualUpdate", false]];

if (ACEGVAR(common,OldIsCamera) || {!alive ACE_player}) exitWith {
    [false, 0] call ACEFUNC(medical_feedback,effectUnconscious);
    [false]    call ACEFUNC(medical_feedback,effectPain);
    [false]    call ACEFUNC(medical_feedback,effectBloodVolume);
    [false]    call ACEFUNC(medical_feedback,effectBloodVolumeIcon);
    [false]    call ACEFUNC(medical_feedback,effectBleeding);
    [false]    call FUNC(effectOxygen);
};

BEGIN_COUNTER(handleEffects);

// - Current state info -------------------------------------------------------
private _bleedingStrength = GET_BLOOD_LOSS(ACE_player);
private _bloodVolume      = GET_EFF_BLOOD_VOLUME(ACE_player);
private _unconscious      = IS_UNCONSCIOUS(ACE_player);
private _heartRate        = GET_HEART_RATE(ACE_player);
private _pain             = GET_PAIN_PERCEIVED(ACE_player);
private _oxygenSaturation = GET_OXYGEN(ACE_player);
private _respirationRate  = GET_RESPIRATION_RATE(ACE_player);
private _chestInjurySeverity = (([((ACE_player getVariable [QEGVAR(breathing,Pneumothorax_State), 0]) * 0.25), 1] select (ACE_player getVariable [QEGVAR(breathing,TensionPneumothorax_State), false])) max ((ACE_player getVariable [QEGVAR(breathing,Hemothorax_Fluid), 0]) * 0.66));
private _criticalState = IN_CRITICAL_STATE(ACE_player);
private _isExposed = IS_EXPOSED(ACE_player); // CBRN

if ((!ACEGVAR(medical_feedback,heartBeatEffectRunning)) && {_heartRate != 0} && {(_heartRate > 140) || {_heartRate < 60}}) then {
    TRACE_1("Starting heart beat effect",_heartRate);
    ACEGVAR(medical_feedback,heartBeatEffectRunning) = true;
    [] call ACEFUNC(medical_feedback,effectHeartBeat);
};

// - Visual effects -----------------------------------------------------------
[_unconscious, 2] call ACEFUNC(medical_feedback,effectUnconscious);
[
    true,
    linearConversion [BLOOD_VOLUME_CLASS_2_HEMORRHAGE, (BLOOD_VOLUME_CLASS_4_HEMORRHAGE + 0.2), _bloodVolume, 0, 1, true]
] call ACEFUNC(medical_feedback,effectBloodVolume);
[
    true,
    ceil linearConversion [
        BLOOD_VOLUME_CLASS_2_HEMORRHAGE, BLOOD_VOLUME_CLASS_4_HEMORRHAGE,
        _bloodVolume,
        ICON_BLOODVOLUME_IDX_MIN, ICON_BLOODVOLUME_IDX_MAX, true
    ]
] call ACEFUNC(medical_feedback,effectBloodVolumeIcon);

[!_unconscious, _pain] call ACEFUNC(medical_feedback,effectPain);
[!_unconscious, _bleedingStrength, _manualUpdate] call ACEFUNC(medical_feedback,effectBleeding);
[!_unconscious, _oxygenSaturation, _respirationRate, _chestInjurySeverity, _criticalState, _isExposed] call FUNC(effectOxygen);

// - Tourniquets, fractures and splints indication ---------------------------------------
if (ACEGVAR(medical_feedback,enableHUDIndicators)) then {
    [] call ACEFUNC(medical_feedback,handleHUDIndicators);
};

END_COUNTER(handleEffects);
