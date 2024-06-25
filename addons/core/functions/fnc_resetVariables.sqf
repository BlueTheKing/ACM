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
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(KnockOut_State), false];
_patient setVariable [QGVAR(TimeOfDeath), nil, true];
_patient setVariable [QGVAR(WasTreated), false, true];

[_patient] call FUNC(generateTargetVitals);
[_patient] call FUNC(getUp);