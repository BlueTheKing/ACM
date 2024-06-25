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
 * [player] call ACM_damage_fnc_resetVariables;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [VAR_WRAPPED_WOUNDS, createHashMap, true];
_patient setVariable [VAR_CLOTTED_WOUNDS, createHashMap, true];
_patient setVariable [VAR_INTERNAL_WOUNDS, createHashMap, true];