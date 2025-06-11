#include "..\script_component.hpp"
/*
 * Author: Blue
 * Play alarm tone.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_AED_PlayTone;
 *
 * Public: No
 */

params ["_patient"];

if ((_patient getVariable [QGVAR(AED_TonePFH), -1]) != -1) exitWith {};

_patient setVariable [QGVAR(AED_TonePFH), -2];

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    if !(_patient getVariable [QGVAR(AED_MotionDetected_Active), false]) exitWith {
        _patient setVariable [QGVAR(AED_TonePFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    playSound3D [QPATHTO_R(sound\aed_alarmtone.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 1s
}, 1, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AED_TonePFH), _PFH];