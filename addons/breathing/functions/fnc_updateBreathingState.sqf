#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update breathing state of patient
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_airway_fnc_updateBreathingState;
 *
 * Public: No
 */

params ["_patient"];

private _state = 1;

if (_patient getVariable [QGVAR(TensionPneumothorax_State), false]) then {
	_state = 0;
} else {
	_state = 1 - ((_patient getVariable [QGVAR(Pneumothorax_State), 0]) / 5);
};

if (IS_UNCONSCIOUS(_patient)) then {
	_state = _state min 0.85;
};

_patient setVariable [QGVAR(BreathingState), _state, true];