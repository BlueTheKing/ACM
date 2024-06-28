#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle pneumothorax deterioration (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_breathing_fnc_handlePneumothorax;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(TensionPneumothorax_State), false]) exitWith {};

private _state = _patient getVariable [QGVAR(Pneumothorax_State), 0];

if (_state > 3) then {
    _patient setVariable [QGVAR(TensionPneumothorax_State), true, true];
} else {
    _state = _state + 1;
    _patient setVariable [QGVAR(Pneumothorax_State), _state, true];
};

[_patient] call FUNC(updateBreathingState);

if (_patient getVariable [QGVAR(Pneumothorax_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _breathingState = GET_BREATHINGSTATE(_patient);
    private _isBreathing = (GET_AIRWAYSTATE(_patient) > 0 && _breathingState > 0);
    private _pneumothoraxState = _patient getVariable [QGVAR(Pneumothorax_State), 0];

    if (!(alive _patient) || !(_patient getVariable [QGVAR(ChestInjury_State), false]) || (_pneumothoraxState < 1 && (_patient getVariable [QGVAR(ChestSeal_State), false])) || _patient getVariable [QGVAR(TensionPneumothorax_State), false] || _patient getVariable [QGVAR(Thoracostomy_State), 0] > 0) exitWith {
        _patient setVariable [QGVAR(Pneumothorax_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if !(_isBreathing) exitWith {};

    if (random 100 < ((40 + _breathingState * 15) * GVAR(pneumothoraxDeteriorateChance))) then {
        _pneumothoraxState = _pneumothoraxState + 1;
        [_patient, (_pneumothoraxState / 4)] call ACEFUNC(medical,adjustPainLevel);
        if (_pneumothoraxState > 4) then {
            _patient setVariable [QGVAR(Pneumothorax_State), 4, true];
            _patient setVariable [QGVAR(TensionPneumothorax_State), true, true];
            if (GVAR(Hardcore_ChestInjury)) then {
                _patient setVariable [QGVAR(Hardcore_Pneumothorax), true, true];
            };
        } else {
            _patient setVariable [QGVAR(Pneumothorax_State), _pneumothoraxState, true];
        };
        [_patient] call FUNC(updateBreathingState);
    };

}, (40 + (random 40)), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Pneumothorax_PFH), _PFH];