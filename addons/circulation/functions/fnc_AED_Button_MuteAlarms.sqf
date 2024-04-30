#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle AED button press to toggle alarms
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_AED_Button_MuteAlarms;
 *
 * Public: No
 */

params ["_patient"];

if (isNull _patient) exitWith {};

private _alarmsActive = _patient getVariable [QGVAR(AED_MuteAlarm), false];

_patient setVariable [QGVAR(AED_MuteAlarm), !_alarmsActive, true];