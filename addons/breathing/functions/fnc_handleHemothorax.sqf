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

[_patient, (linearConversion [1, 10, _state, 0.3, 1, true])] call ACEFUNC(medical,adjustPainLevel);

[_patient] call FUNC(updateBreathingState);

if (_patient getVariable [QGVAR(Hemothorax_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _hemothoraxState = _patient getVariable [QGVAR(Hemothorax_State), 0];

    if (GVAR(Hardcore_HemothoraxBleeding) && _hemothoraxState == 1) exitWith {};

    private _plateletCount = _patient getVariable [QEGVAR(circulation,Platelet_Count), 3];
    private _TXAEffect = [_patient, "TXA_IV", false] call ACEFUNC(medical_status,getMedicationCount);

    if (!(alive _patient) || _hemothoraxState == 0) exitWith {
        _patient setVariable [QGVAR(Hemothorax_PFH), -1];
        [_patient] call FUNC(updateBreathingState);
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (_plateletCount > 1 || _TXAEffect > 0.1) then {
        if (random 1 < ((0.35 * _plateletCount / 4) max (0.9 * (_TXAEffect min 1.2)))) then {
            private _clearAmount = 1;
            
            if (_TXAEffect >= 1) then {
                _clearAmount = ([2,3] select (random 1 < (0.3 * _TXAEffect)));
            };

            _hemothoraxState = (_hemothoraxState - _clearAmount) max 0;

            _patient setVariable [QGVAR(Hemothorax_State), _hemothoraxState, true];
        };
    };

    [_patient] call FUNC(updateBreathingState);
}, (15 + (random 15)), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Hemothorax_PFH), _PFH];