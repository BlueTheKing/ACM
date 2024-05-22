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
 * [player, cursorTarget] call ACM_circulation_fnc_AED_TrackCPR;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(AED_TrackingCPR), true, true];
_patient setVariable [QGVAR(AED_TrackedCPR_Time), (CBA_missionTime + 2), true];

GVAR(loopTime_cpr) = 0;

[{ // Reminder to re-analyze
    params ["_patient"];

    playSound3D [QPATHTO_R(sound\aed_checkpulse_nopulsepushanalyze.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 7.375s
}, [_patient], 120] call CBA_fnc_waitAndExecute;

[{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    // Kill PFH once CPR is stopped after 2 minutes
    if (((_patient getVariable [QGVAR(AED_TrackedCPR_Time), 0]) + 120) < CBA_missionTime || !([_patient] call FUNC(hasAED))) exitWith {
        _patient setVariable [QGVAR(AED_TrackingCPR), false, true];
        _patient setVariable [QGVAR(AED_TrackedCPR_Time), -1, true];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if ((GVAR(loopTime_cpr) + 0.6) > CBA_missionTime || (_patient getVariable [QGVAR(AED_MuteCPR), false])) exitWith {};

    GVAR(loopTime_cpr) = CBA_missionTime;
    playSound3D [QPATHTO_R(sound\aed_cprtick.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.058s
}, 0, [_patient]] call CBA_fnc_addPerFrameHandler;