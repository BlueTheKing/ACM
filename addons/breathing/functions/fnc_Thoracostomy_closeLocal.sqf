#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle closing up Thoracostomy incision (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_closeLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

["Thoracostomy incision sealed and one-way valve placed", 2, _medic] call ACEFUNC(common,displayTextStructured);

_patient setVariable [QGVAR(Thoracostomy_State), 0, true];
_patient setVariable [QGVAR(Pneumothorax_State), 0, true];