#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform (finger) thoracostomy on patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_startLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = "Finger Thoracostomy Performed";
private _diagnose = switch (true) do {
	case (_patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0.9): {
		"Large amount of blood in pleural space, lung is severely collapsed";
	};
	case (_patient getVariable [QGVAR(Hemothorax_State), 0] > 0): {
		"Noticable bleeding inside pleural space";
	};
	case (_patient getVariable [QGVAR(TensionPneumothorax_State), false]): {
		"Lung is severely collapsed";
	};
	default {
		"Lung is inflating normally";
	};
};

[(format ["%1<br/>%2", _hint, _diagnose]), 2.5, _medic] call ACEFUNC(common,displayTextStructured);

_patient setVariable [QGVAR(Thoracostomy_State), 1, true];

if !(IS_UNCONSCIOUS(_patient)) then {
    [_patient, 1] call ACEFUNC(medical,adjustPainLevel);
};

_patient setVariable [QGVAR(TensionPneumothorax_State), false, true];
_patient setVariable [QGVAR(Pneumothorax_State), 3, true];

[_patient] call FUNC(updateBreathingState);