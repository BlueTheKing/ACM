#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check breathing of patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call AMS_breathing_fnc_checkBreathing;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[QGVAR(checkBreathingLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;