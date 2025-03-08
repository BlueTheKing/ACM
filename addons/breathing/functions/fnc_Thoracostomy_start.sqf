#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform (finger) thoracostomy on patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Used Kit <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, false] call ACM_breathing_fnc_Thoracostomy_start;
 *
 * Public: No
 */

params ["_medic", "_patient", "_usedKit"];

if ((_patient getVariable [QGVAR(Thoracostomy_State), -1]) == 1) exitWith {
    [LLSTRING(ThoracostomySweep_Already), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

[_patient, "activity", ([LLSTRING(ThoracostomySweep_ActionLog_Complete), LLSTRING(ThoracostomySweep_Kit_ActionLog_Complete)] select _usedKit), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(Thoracostomy_startLocal), [_medic, _patient, _usedKit], _patient] call CBA_fnc_targetEvent;