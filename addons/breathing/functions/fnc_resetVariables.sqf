#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset breathing variables to default values (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_breathing_fnc_resetVariables;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(Pneumothorax_State), 0];
_patient setVariable [QGVAR(TensionPneumothorax_State), false];

_patient setVariable [QGVAR(ChestSeal_State), false, true];

_patient setVariable [QGVAR(PulseOximeter_Display), [[0,0],[0,0]], true]; 
_patient setVariable [QGVAR(PulseOximeter_Placement), [false,false], true];
_patient setVariable [QGVAR(PulseOximeter_PFH), [-1,-1]];
_patient setVariable [QGVAR(PulseOximeter_LastSync), [-1,-1]];

//_patient setVariable [QGVAR(OxygenSaturation), 100, true]; handled by ace

[_patient] call FUNC(updateBreathingState);