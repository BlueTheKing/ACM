#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get EtCO2 of patient.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * End-Tidal Carbon Dioxide (mmHg) <NUMBER>
 *
 * Example:
 * [player] call ACM_breathing_fnc_getEtCO2;
 *
 * Public: No
 */

params ["_patient"];

/* mmHg 
    Cardiac Arrest - 0 
    Effective CPR - 10-20
    Unconscious - 30-35
    Conscious (Normal) - 35-45
    ROSC (Momentary) - 45-50
*/
private _timeSinceROSC = (CBA_missionTime - (_patient getVariable [QEGVAR(circulation,ROSC_Time), -30]));
private _exit = false;
private _minFrom = 0;
private _maxFrom = 0;
private _value = 0;
private _minTo = 0;
private _maxTo = 0;

private _airwayState = (GET_AIRWAYSTATE(_patient) / 0.95) min 1;
private _breathingState = (GET_BREATHINGSTATE(_patient) / 0.85) min 1;

if (_timeSinceROSC < 30) exitWith {
    linearConversion [0, 30, _timeSinceROSC, 50, 30, true];
};

private _desiredRespirationRate = _patient getVariable [QEGVAR(core,TargetVitals_RespirationRate), 16];

if ((GET_HEART_RATE(_patient) < 20) || IN_CRDC_ARRST(_patient) || !(alive _patient)) then {
    if (alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull])) then {
        _minFrom = 100;
        _maxFrom = 120;
        _value = GET_HEART_RATE(_patient);
        _minTo = 10;
        _maxTo = 20;
    } else {
        _exit = true;
    };
} else {
    _value = GET_RESPIRATION_RATE(_patient);
    if (_value < _desiredRespirationRate) then {
        _minFrom = 1;
        _maxFrom = _desiredRespirationRate;
        if (IS_UNCONSCIOUS(_patient)) then {
            _minTo = 35;
            _maxTo = 30;
        } else {
            _minTo = 45;
            _maxTo = 35;
        };
    } else {
        _minFrom = _desiredRespirationRate;
        _maxFrom = 50;
        if (IS_UNCONSCIOUS(_patient)) then {
            _minTo = 30;
            _maxTo = 15;
        } else {
            _minTo = 35;
            _maxTo = 20;
        };
    };
};

if (_exit) exitWith {0};

linearConversion [_minFrom, _maxFrom, (_value * (_airwayState min _breathingState)), _minTo, _maxTo, true];