#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update lung state of patient
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Was Healed <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, false] call ACM_airway_fnc_updateLungState;
 *
 * Public: No
 */

params ["_patient", ["_healed", false]];

if (_healed) exitWith {
    _patient setVariable [QGVAR(Stethoscope_LungState), [0,0], true];
};

private _lungState = _patient getVariable [QGVAR(Stethoscope_LungState), [0,0]];

private _affectedIndex = _lungState findIf {_x > 0};

if (_affectedIndex == -1) then {
    _affectedIndex = round (random 1);
};

private _state = 0;

private _PTXState = _patient getVariable [QGVAR(Pneumothorax_State), 0];
private _TPTXState = _patient getVariable [QGVAR(TensionPneumothorax_State), false];
private _HTXFluid = _patient getVariable [QGVAR(Hemothorax_Fluid), 0];

switch (true) do {
    case (_TPTXState ||_HTXFluid > 1.1): {
        _state = 2;
    };
    case (_PTXState > 0 || _HTXFluid > 0.3): {
        _state = 1;
    };
    default {};
};

if (_state == 0) exitWith {
    _patient setVariable [QGVAR(Stethoscope_LungState), [0,0], true];
};

_lungState set [_affectedIndex, _state];

_patient setVariable [QGVAR(Stethoscope_LungState), _lungState, true];