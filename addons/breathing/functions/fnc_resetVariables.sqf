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

_patient setVariable [QGVAR(ChestInjury_State), false, true];

_patient setVariable [QGVAR(Pneumothorax_State), 0, true];
_patient setVariable [QGVAR(TensionPneumothorax_State), false, true];

_patient setVariable [QGVAR(ChestSeal_State), false, true];

_patient setVariable [QGVAR(PulseOximeter_Display), [[0,0],[0,0]], true]; 
_patient setVariable [QGVAR(PulseOximeter_Placement), [false,false], true];
_patient setVariable [QGVAR(PulseOximeter_PFH), -1];
_patient setVariable [QGVAR(PulseOximeter_LastSync), [-1,-1]];

[_patient] call FUNC(updateBreathingState);