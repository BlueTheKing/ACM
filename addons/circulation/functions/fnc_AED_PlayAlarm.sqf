#include "..\script_component.hpp"
/*
 * Author: Blue
 * Play cardiac arrest alarm
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_AED_PlayAlarm;
 *
 * Public: No
 */

params ["_patient"];

if ((_patient getVariable [QGVAR(AED_AlarmPFH), -1]) != -1) exitWith {};

playSound3D [QPATHTO_R(sound\aed_checkpatient.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 1.837s

_patient setVariable [QGVAR(AED_AlarmPFH), -2];

[{
    params ["_patient"];

    private _PFH = [{
        params ["_args", "_idPFH"];
        _args params ["_patient"];

        if (!([_patient] call FUNC(hasAED)) || !(_patient getVariable [QGVAR(AED_Alarm_State), false])) exitWith {
            _patient setVariable [QGVAR(AED_AlarmPFH), -1];
            [_idPFH] call CBA_fnc_removePerFrameHandler;
        };

        if (_patient getVariable [QGVAR(AED_InUse), false] || {[_patient] call FUNC(AED_IsSilent)}) exitWith {};

        playSound3D [QPATHTO_R(sound\aed_alarm.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.528s
    }, 0.528, [_patient]] call CBA_fnc_addPerFrameHandler;

    _patient setVariable [QGVAR(AED_AlarmPFH), _PFH];
}, [_patient, _medic], 1.84] call CBA_fnc_waitAndExecute;