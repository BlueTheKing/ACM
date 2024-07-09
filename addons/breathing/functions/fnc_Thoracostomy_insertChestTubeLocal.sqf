#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle inserting chest tube (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_insertChestTubeLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[QACEGVAR(common,displayTextStructured), ["Chest Tube inserted", 1.5, _medic], _medic] call CBA_fnc_targetEvent;

_patient setVariable [QGVAR(Thoracostomy_State), 2, true];