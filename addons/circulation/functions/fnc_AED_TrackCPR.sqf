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

    //playSound3D [QPATHTO_R(sound\aed_2beep.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 0.0s

    GVAR(loopTime_cpr) = 0;

    [{
        params ["_args", "_idPFH"];
        _args params ["_patient"];

        // Kill PFH if CPR stops for 10 seconds
        if (isNull (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull]) && {((_patient getVariable [QGVAR(CPR_StoppedTime), 0]) + 10) < CBA_missionTime}) exitWith {
            [_idPFH] call CBA_fnc_removePerFrameHandler;
        };

        if ((GVAR(loopTime_cpr) + 0.6) > CBA_missionTime) exitWith {};

        GVAR(loopTime_cpr) = CBA_missionTime;
        //playSound3D [QPATHTO_R(sound\aed_cprtick.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 0.0s
    }, 0, [_patient]] call CBA_fnc_addPerFrameHandler;
}, [_patient], 30] call CBA_fnc_waitUntilAndExecute;