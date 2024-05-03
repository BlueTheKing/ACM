#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update oxygen saturation
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Time since last update <NUMBER>
 * 2: Sync value? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_breathing_fnc_updateOxygenSaturation;
 *
 * Public: No
 */

params ["_unit", "_deltaT", "_syncValue"];

private _unitDesiredSaturation = _unit getVariable [QEGVAR(core,TargetVitals_OxygenSaturation), 99];

private _effectiveBloodVolume = (((_unit getVariable [QEGVAR(circulation,Blood_Volume), 6]) + ((_unit getVariable [QEGVAR(circulation,Plasma_Volume), 0]) * 0.3)) min 4.5) / 4.5;

private _oxygenSaturation = _unit getVariable [QGVAR(OxygenSaturation), 100];
private _targetSaturation = _unitDesiredSaturation;
private _saturationChange = 0;

private _CPR = alive (_unit getVariable [QACEGVAR(medical,CPR_provider), objNull]);
private _oxygenationPeriod = _CPR || ((_unit getVariable [QEGVAR(circulation,CPR_OxygenationPeriod), -1]) > (CBA_missionTime + 30));

private _BVMActive = alive (_unit getVariable [QGVAR(BVM_provider), objNull]);
private _oxygenAssisted = false;

private _positiveChangeRate = 60;
private _negativeChangeRate = 120;
private _saturationChangeCap = 1;

private _breathingState = _unit getVariable [QGVAR(BreathingState), 1];
private _unAssisted = false;

switch (true) do {
    case (_oxygenAssisted): {
        _positiveChangeRate = 50;
        _breathingState = _breathingState * 3;
    };
    case (_BVMActive && _oxygenationPeriod): {
        _positiveChangeRate = 80;
        _breathingState = _breathingState * 1.5;
    };
    case (_CPR): {
        _positiveChangeRate = 90;
        
        if (IN_CRDC_ARRST(_unit)) then {
            _breathingState = _breathingState * 1.1;
        };
    };
    case (IN_CRDC_ARRST(_unit)): {
        _saturationChangeCap = 0.1;
        _unAssisted = true;
    };
    case (IS_UNCONSCIOUS(_unit)): {
        _positiveChangeRate = 120;
    };
    default {};
};

private _airwayState = _unit getVariable [QEGVAR(airway,AirwayState), 1];

private _breathingEffectiveness = (_airwayState min _effectiveBloodVolume) * _breathingState;

if (!_unAssisted && _breathingEffectiveness > 0) then {
    _targetSaturation = linearConversion [0, 1, _breathingEffectiveness, 55, _unitDesiredSaturation, true];
} else {
    _targetSaturation = 0;
};

if (_targetSaturation > _oxygenSaturation) then {
    _saturationChange = ((_targetSaturation - _oxygenSaturation) * _breathingEffectiveness) / _positiveChangeRate;
    _saturationChange = _saturationChange min _saturationChangeCap;
    _oxygenSaturation = (_oxygenSaturation + _deltaT * _saturationChange) min _targetSaturation;
} else {
    _saturationChange = (_targetSaturation - _oxygenSaturation) / _negativeChangeRate;
    _saturationChange = _saturationChange max -_saturationChangeCap;
    _oxygenSaturation = (_oxygenSaturation + _deltaT * _saturationChange) max _targetSaturation;
};

_unit setVariable [QGVAR(OxygenSaturation), _oxygenSaturation, _syncValue];