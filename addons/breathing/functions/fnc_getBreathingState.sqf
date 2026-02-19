#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get breathing state of patient
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Breathing State <NUMBER>
 *
 * Example:
 * [player] call ACM_breathing_fnc_getBreathingState;
 *
 * Public: No
 */

params ["_patient"];

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

if (_hardcorePTX) then {
    _state = _state min ([0.8, 0.95] select (IN_CRDC_ARRST(_patient)));
};

private _exposureBreathingState = GET_EXPOSURE_BREATHINGSTATE(_patient);

if (_exposureBreathingState < 1) then {
    _state = _state * _exposureBreathingState;
};

_state;