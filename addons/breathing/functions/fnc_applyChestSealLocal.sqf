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
 * [player, cursorTarget] call ACM_breathing_fnc_applyChestSealLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if (_patient getVariable [QGVAR(Pneumothorax_State), 0] > 0) then {
	_patient setVariable [QGVAR(Pneumothorax_State), 0, true];
	[_patient] call FUNC(updateBreathingState);
};

_patient setVariable [QGVAR(ChestSeal_State), true, true];