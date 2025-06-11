#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle motion being detected while analyzing.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_circulation_fnc_AED_MotionDetected;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if (_patient getVariable [QGVAR(AED_MotionDetected_Active), false]) exitWith {};

_patient setVariable [QGVAR(AED_MotionDetected_Active), true, true];

_patient setVariable [QGVAR(AED_MotionDetected_LastMotion), CBA_missionTime];

[{
    params ["_patient"];

    playSound3D [QPATHTO_R(sound\aed_motiondetected.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 2.811s
}, [_patient], 0.3] call CBA_fnc_waitAndExecute;

[_patient] call FUNC(AED_PlayTone);

[{
    params ["_args", "_idPFH"];
    _args params ["_medic", "_patient"];

    private _motionCeased = (_patient getVariable [QGVAR(AED_MotionDetected_LastMotion), -1]) + 2 < CBA_missionTime;
    
    if (!([_patient] call FUNC(hasAED)) || _motionCeased || !(_patient getVariable [QGVAR(AED_Analyze_Busy), false])) exitWith {
        if (_motionCeased) then {
            [{
                params ["_medic", "_patient"];

                [_medic, _patient, true] call FUNC(AED_AnalyzeRhythm);
            }, [_medic, _patient], 1.5] call CBA_fnc_waitAndExecute;
        } else {
            playSound3D [QPATHTO_R(sound\aed_3beep.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.624s
        };

        _patient setVariable [QGVAR(AED_MotionDetected_Active), false, true];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if ((alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull])) || (alive (_patient getVariable [QEGVAR(breathing,BVM_provider), objNull]))) then {
        _patient setVariable [QGVAR(AED_MotionDetected_LastMotion), CBA_missionTime];
    };
}, 0.25, [_medic, _patient]] call CBA_fnc_addPerFrameHandler;