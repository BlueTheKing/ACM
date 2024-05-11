#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update breathing state of patient
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Was Healed <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, false] call ACM_airway_fnc_updateBreathingState;
 *
 * Public: No
 */

params ["_patient", ["_healed", false]];

private _state = 1;

private _PTXState = _patient getVariable [QGVAR(Pneumothorax_State), 0];
private _TPTXState = _patient getVariable [QGVAR(TensionPneumothorax_State), false];

if (_TPTXState) then {
    _state = 0.05;
} else {
    _state = 1 - (_PTXState / 5);
};

if (IS_UNCONSCIOUS(_patient)) then {
    _state = _state min 0.85;
};

[_patient, _healed] call FUNC(updateLungState);

_patient setVariable [QGVAR(BreathingState), _state, true];