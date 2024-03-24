#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle pneumothorax deterioration
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_breathing_fnc_handlePneumothorax;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(TensionPneumothorax_State), false]) exitWith {};

private _state = _patient getVariable [QGVAR(Pneumothorax_State), 0];

if (_state > 3) then {
    _patient setVariable [QGVAR(TensionPneumothorax_State), true];
} else {
    _state = _state + 1;
    _patient setVariable [QGVAR(Pneumothorax_State), _state];
};

[_patient] call FUNC(updateBreathingState);

if (_patient getVariable [QGVAR(Pneumothorax_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _breathingState = _patient getVariable [QGVAR(BreathingState), 0];
    private _isBreathing = (_patient getVariable [QEGVAR(airway,AirwayState), 0] > 0 && _breathingState > 0);
    private _pneumothoraxState = _patient getVariable [QGVAR(Pneumothorax_State), 0];

    if (_pneumothoraxState < 1 || _patient getVariable [QGVAR(TensionPneumothorax_State), false]) exitWith {
        _patient setVariable [QGVAR(Pneumothorax_PFH), -1];
        _patient setVariable [QGVAR(Pneumothorax_State), 0];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if !(_isBreathing) exitWith {};

    if (random 100 < (50 + _breathingState * 15)) then { // TODO settable chance
        _pneumothoraxState = _pneumothoraxState + 1;
        if (_pneumothoraxState > 4) then {
            _patient setVariable [QGVAR(Pneumothorax_State), 4];
            _patient setVariable [QGVAR(TensionPneumothorax_State), true];
        } else {
            _patient setVariable [QGVAR(Pneumothorax_State), _pneumothoraxState];
        };
        [_patient] call FUNC(updateBreathingState);
    };

}, (25 + (random 10)), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Pneumothorax_PFH), _PFH];