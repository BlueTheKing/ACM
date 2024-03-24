#include "..\script_component.hpp"
/*
 * Author: Blue
 * Use chest seal on patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call AMS_breathing_fnc_applyChestSealLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

_patient setVariable [QGVAR(Pneumothorax_State), -1];

_patient setVariable [QGVAR(ChestSeal_State), true, true];

[_patient] call FUNC(updateBreathingState);