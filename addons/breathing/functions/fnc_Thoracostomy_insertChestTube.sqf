#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle inserting chest tube
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_insertChestTube;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if ((_patient getVariable [QGVAR(Thoracostomy_State), -1]) == 2) exitWith {
    ["Chest Tube already inserted", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
};

[_patient, "activity", "%1 inserted Chest Tube", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(Thoracostomy_insertChestTubeLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;