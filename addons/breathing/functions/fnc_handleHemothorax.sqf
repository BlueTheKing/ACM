#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle hemothorax process (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_breathing_fnc_handleHemothorax;
 *
 * Public: No
 */

params ["_patient"];

private _state = _patient getVariable [QGVAR(Hemothorax_State), 0];

if (_state >= 10) exitWith {};

if (_state == 0) then {
    _state = 5 + round (random 5);
} else {
    _state = _state + 1;
};

_patient setVariable [QGVAR(Hemothorax_State), _state, true];

[_patient, (linearConversion [1, 6, _state, 0.3, 1, true])] call ACEFUNC(medical,adjustPainLevel);

if (_patient getVariable [QGVAR(Hemothorax_PFH), -1] != -1) exitWith {};

private _time = [(10 + (random 10)), (15 + (random 15))] select GVAR(Hardcore_HemothoraxBleeding);

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _hemothoraxState = _patient getVariable [QGVAR(Hemothorax_State), 0];

    if (GVAR(Hardcore_HemothoraxBleeding) && _hemothoraxState <= 2) exitWith {};

    private _plateletCount = _patient getVariable [QEGVAR(circulation,Platelet_Count), 3];
    private _TXACount = ([_patient, "TXA_IV", false] call ACEFUNC(medical_status,getMedicationCount)) min 2;

    if (!(alive _patient) || _hemothoraxState == 0) exitWith {
        _patient setVariable [QGVAR(Hemothorax_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (GET_HEART_RATE(_patient) < 20 || (_plateletCount < 1 && _TXACount < 0.1) || (GET_EFF_BLOOD_VOLUME(_patient) < 3.6)) exitWith {};
    
    if (random 1 < ((0.25 * _plateletCount / 4) max (0.5 * (_TXACount min 1.2)))) then {
        private _clearAmount = 1;
        
        if (_TXACount >= 1) then {
            _clearAmount = ([2,3] select (random 1 < (0.25 * _TXACount)));
        };

        _hemothoraxState = (_hemothoraxState - _clearAmount) max ([0, 2] select GVAR(Hardcore_HemothoraxBleeding));

        _patient setVariable [QGVAR(Hemothorax_State), _hemothoraxState, true];
    };
}, _time, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Hemothorax_PFH), _PFH];