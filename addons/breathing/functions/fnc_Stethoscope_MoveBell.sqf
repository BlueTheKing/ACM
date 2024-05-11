#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle moving bell in stethoscope dialog.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Stethoscope_MoveBell;
 *
 * Public: No
 */

params ["_medic", "_patient"];

GVAR(Stethoscope_BellMoving) = !GVAR(Stethoscope_BellMoving);