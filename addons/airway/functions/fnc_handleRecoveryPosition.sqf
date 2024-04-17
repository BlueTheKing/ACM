#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle cancelling recovery position state (locally)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_airway_fnc_handleRecoveryPosition;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[{
    params ["_patient"];

    _patient call ACEFUNC(medical_status,isBeingDragged) || _patient call ACEFUNC(medical_status,isBeingCarried) || !(_patient getVariable [QGVAR(RecoveryPosition_State), false]) || !(isNull objectParent _patient);
}, {
    params ["_patient", "_medic"];

    if (_patient getVariable [QGVAR(RecoveryPosition_State), false]) then {
        [_medic, _patient, false, true] call FUNC(setRecoveryPosition);
    };
}, [_patient, _medic], 3600] call CBA_fnc_waitUntilAndExecute;
