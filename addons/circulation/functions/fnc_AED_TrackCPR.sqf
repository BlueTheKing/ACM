#include "..\script_component.hpp"
/*
 * Author: Blue
 * Track CPR performed after shock or analyze rhythm advice
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call AMS_circulation_fnc_AED_TrackCPR;
 *
 * Public: No
 */

params ["_patient"];

[{
    params ["_patient"];

    alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull]);
}, {
    params ["_patient"];

    _patient setVariable [QGVAR(AED_MuteAlarm), true, true];

    playSound3D [QPATHTO_R(sound\aed_3beep.wav), _patient, false, getPosASL _patient, 10, 1, 10]; // 0.369s

    GVAR(loopTime_cpr) = 0;

    [{ // Reminder to re-analyze
        params ["_patient", "_medic"];

        playSound3D [QPATHTO_R(sound\aed_checkpulse_nopulsepushanalyze.wav), _patient, false, getPosASL _patient, 10, 1, 10]; // 7.375s
    }, [_patient, _medic], 120] call CBA_fnc_waitAndExecute;

    [{
        params ["_args", "_idPFH"];
        _args params ["_patient"];

        // Kill PFH if CPR stops for 30 seconds
        if (isNull (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull]) && {((_patient getVariable [QGVAR(CPR_StoppedTime), CBA_missionTime]) + 30) < CBA_missionTime}) exitWith {
            systemchat format ["%1",(_patient getVariable [QGVAR(CPR_StoppedTime), 0])];
            _patient setVariable [QGVAR(AED_MuteAlarm), false, true];
            [_idPFH] call CBA_fnc_removePerFrameHandler;
        };

        if ((GVAR(loopTime_cpr) + 0.6) > CBA_missionTime) exitWith {};

        GVAR(loopTime_cpr) = CBA_missionTime;
        playSound3D [QPATHTO_R(sound\aed_cprtick.wav), _patient, false, getPosASL _patient, 10, 1, 10]; // 0.058s
    }, 0, [_patient]] call CBA_fnc_addPerFrameHandler;
}, [_patient], 30] call CBA_fnc_waitUntilAndExecute;