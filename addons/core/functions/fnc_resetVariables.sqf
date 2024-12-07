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
_patient setVariable [QGVAR(WasWounded), false, true];

_patient setVariable [QGVAR(CarryAssist_State), false, true];

if (isPlayer _patient) then {
    _patient setVariable [QGVAR(TreatmentText_Providers), []];
};

_patient setVariable [QGVAR(CriticalVitals_State), false, true];
_patient setVariable [QGVAR(CriticalVitals_Passed), false, true];

[_patient] call FUNC(generateTargetVitals);
[_patient] call FUNC(getUp);