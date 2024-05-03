#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Handles the hear beat sound.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ace_medical_feedback_fnc_effectHeartBeat
 *
 * Public: No
 */

if (ACEGVAR(common,OldIsCamera)) exitWith {
    TRACE_2("Ending heart beat effect - scripted camera",_heartRate,ACEGVAR(common,OldIsCamera));
    ACEGVAR(medical_feedback,heartBeatEffectRunning) = false;
};

private _heartRate = GET_HEART_RATE(ACE_player);
if (_heartRate == 0) exitWith {
    TRACE_1("Ending heart beat effect - zero",_heartRate);
    ACEGVAR(medical_feedback,heartBeatEffectRunning) = false;
};
private _waitTime = 60 / _heartRate;

// TRACE_2("",_heartRate,_waitTime);

switch (true) do {
    case (_heartRate > 140): {
        // playSound SND_HEARBEAT_FAST; // Array doesn't blend together well, just play one file consistently
        if (isGameFocused) then { playSound "ACE_heartbeat_fast_1"; };
        [ACEFUNC(medical_feedback,effectHeartBeat), [], _waitTime] call CBA_fnc_waitAndExecute;
    };
    case (_heartRate < 60): {
        if (isGameFocused) then { playSound SND_HEARBEAT_SLOW; };
        [ACEFUNC(medical_feedback,effectHeartBeat), [], _waitTime] call CBA_fnc_waitAndExecute;
    };
    default {
        TRACE_1("Ending heart beat effect - normal",_heartRate);
        ACEGVAR(medical_feedback,heartBeatEffectRunning) = false;
    };
};
