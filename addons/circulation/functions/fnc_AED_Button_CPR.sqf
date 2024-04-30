#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle AED button press to toggle CPR sound
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_AED_Button_CPR;
 *
 * Public: No
 */

params ["_patient"];

if (isNull _patient) exitWith {};

private _soundActive = _patient getVariable [QGVAR(AED_MuteCPR), false];

_patient setVariable [QGVAR(AED_MuteCPR), !_soundActive, true];