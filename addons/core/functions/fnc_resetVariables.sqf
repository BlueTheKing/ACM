#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset variables.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_resetVariables;
 */

params ["_patient"];

_patient setVariable [QGVAR(WasTreated), false, true];