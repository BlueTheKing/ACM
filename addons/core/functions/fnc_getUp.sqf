#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get up patient from lying state.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_getUp;
 */

params ["_patient"];

_patient setVariable [QGVAR(Lying_State), false, true];
[_patient, "UnconsciousOutProne", 2] call ACEFUNC(common,doAnimation);