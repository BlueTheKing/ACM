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
    Hyperventilation - 45-50
*/

private _exit = false;
private _minFrom = 0;
private _maxFrom = 0;
private _value = 0;
private _minTo = 0;
private _maxTo = 0;

private _airwayState = (GET_AIRWAYSTATE(_patient) / 0.95) min 1;
private _breathingState = (GET_BREATHINGSTATE(_patient) / 0.85) min 1;

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
    _minFrom = _patient getVariable [QEGVAR(core,TargetVitals_RespirationRate), 16];
    _maxFrom = 50;
    _value = GET_RESPIRATION_RATE(_patient);
    if (IS_UNCONSCIOUS(_patient)) then {
        _minTo = 30;
        _maxTo = 45;
    } else {
        _minTo = 35;
        _maxTo = 50;
    };
};

if (_exit) exitWith {0};

linearConversion [_minFrom, _maxFrom, (_value * _airwayState * _breathingState), _minTo, _maxTo, true];