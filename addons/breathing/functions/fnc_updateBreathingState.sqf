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

private _HTXState = _patient getVariable [QGVAR(Hemothorax_State), 0];
private _HTXFluid = _patient getVariable [QGVAR(Hemothorax_Fluid), 0];

private _PTXState = _patient getVariable [QGVAR(Pneumothorax_State), 0];
private _TPTXState = _patient getVariable [QGVAR(TensionPneumothorax_State), false];

private _hardcorePTX = _patient getVariable [QGVAR(Hardcore_Pneumothorax), false];

if (_HTXFluid > 0.3) then {
    _state = 1 - (0.9 * (_HTXFluid / 1.5));
};

if (_TPTXState) then {
    _state = 0.1;
} else {
    _state = _state - (_PTXState / 10);
};

[_patient, _healed] call FUNC(updateLungState);

if (_hardcorePTX) then {
    _state = _state min 0.8;
};

if (_healed) then {
    _state = 1;
};

_patient setVariable [QGVAR(BreathingState), _state, true];