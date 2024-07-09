#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle closing up Thoracostomy incision
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_close;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if ((_patient getVariable [QGVAR(Thoracostomy_State), -1]) == 0) exitWith {
    ["Thoracostomy incision already closed", 2, _medic] call ACEFUNC(common,displayTextStructured);
};

[_patient, "activity", "%1 closed up thoracostomy incision", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(Thoracostomy_closeLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;