#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset circulation variables to default values
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_circulation_fnc_resetVariables;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(IV_Placement), [0,0,0,0,0,0], true];
_patient setVariable [QGVAR(Blood_Volume), 6, true];
_patient setVariable [QGVAR(Plasma_Volume), 0, true];
_patient setVariable [QGVAR(Saline_Volume), 0, true];

[_patient] call FUNC(updateCirculationState);
[_patient] call FUNC(generateBloodType);