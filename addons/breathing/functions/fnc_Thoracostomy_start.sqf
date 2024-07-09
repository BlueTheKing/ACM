#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform (finger) thoracostomy on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_start;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if ((_patient getVariable [QGVAR(Thoracostomy_State), -1]) == 1) exitWith {
    ["Thoracostomy sweep already performed", 2, _medic] call ACEFUNC(common,displayTextStructured);
};

[_patient, "activity", "%1 performed thoracostomy", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(Thoracostomy_startLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;