#include "..\script_component.hpp"
/*
 * Author: Blue
 * Unload patient from vehicle and carry (skip animation)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_core_fnc_unloadAndCarryPatient;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[_medic, _patient] call ACEFUNC(medical_treatment,unloadUnit);
_patient setVariable [QACEGVAR(common,owner), _medic, true];

[{
    params ["_medic", "_patient"];

    [QACEGVAR(dragging,startCarry), [_medic, _patient, true, true], _medic] call CBA_fnc_targetEvent;
}, [_medic, _patient], 0.25] call CBA_fnc_waitAndExecute;