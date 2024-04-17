#include "..\script_component.hpp"
/*
 * Author: Blue
 * Inspect chest of patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_inspectChest;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[QGVAR(inspectChestLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;