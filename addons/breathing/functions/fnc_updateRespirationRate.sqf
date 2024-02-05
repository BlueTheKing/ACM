#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update respiration rate
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1:  <NUMBER>
 * 2: Time since last update <NUMBER>
 * 3: Sync value? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_breathing_fnc_updateRespirationRate;
 *
 * Public: No
 */

params ["_unit", "_what", "_deltaT", "_syncValue"];

// 12-20 per min          40-60 per min

private _unitDesiredRespirationRate = _unit getVariable [QEGVAR(core,TargetVitals_RespirationRate), 16];

private _oxygenSaturation = _unit getVariable [QGVAR(OxygenSaturation), 0];

private _respirationRate = _unit getVariable [QGVAR(RespirationRate), 0];
private _targetRespirationRate = _unitDesiredRespirationRate;

private _respirationRateChange = 0;

if (IN_CRDC_ARRST(_unit)) then {
    _targetRespirationRate = 0;
    if (false) then {}; // TODO BVM
    if (false) then {}; // TODO CPR

    _respirationRateChange = (_targetRespirationRate - _respirationRate);
} else { // TODO affected by airway + breathing state

    _targetRespirationRate = linearConversion [(_unit getVariable [QEGVAR(core,TargetVitals_OxygenSaturation), 100]), 60, _oxygenSaturation, _unitDesiredRespirationRate, 30, true];

    _respirationRateChange = (_targetRespirationRate - _respirationRate) / 3;
};

if (_targetRespirationRate > 0) then {
    _respirationRate = (_respirationRate + _deltaT * _respirationRateChange) min _targetRespirationRate;
} else {
    _respirationRate = (_respirationRate + _deltaT * _respirationRateChange) max _targetRespirationRate;
};

_unit setVariable [QGVAR(RespirationRate), _respirationRate, _syncValue];