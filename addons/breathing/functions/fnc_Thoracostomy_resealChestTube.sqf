#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle resealing chest tube
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_resealChestTube;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if ((_patient getVariable [QGVAR(Thoracostomy_State), -1]) == 2) exitWith {
    [LLSTRING(ThoracostomyResealChestTube_Already), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
};

[_patient, "activity", LLSTRING(ThoracostomyResealChestTube_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(Thoracostomy_resealChestTubeLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;