#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update respiration rate
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Oxygen Saturation <NUMBER>
 * 2: Oxygen Demand <NUMBER>
 * 3: Respiration Rate Adjustment <NUMBER>
 * 4: Carbon Dioxide Sensitivity Adjustment <NUMBER>
 * 5: Time since last update <NUMBER>
 * 6: Sync value? <BOOL>
 *
 * Return Value:
 * Respiration Rate <NUMBER>
 *
 * Example:
 * [player, 80, -0.25 1, false] call ACM_breathing_fnc_updateRespirationRate;
 *
 * Public: No
 */

params ["_unit", "_oxygenSaturation", ["_oxygenDemand", 0], ["_respirationRateAdjustment", 0], "_coSensitivityAdjustment", "_deltaT", "_syncValue"];
// 12-20 per min          40-60 per min

private _respirationRate = GET_RESPIRATION_RATE(_unit);
private _isBreathing = (GET_AIRWAYSTATE(_unit) > 0) && (GET_BREATHINGSTATE(_unit) > 0);

switch (true) do {
    case !(_isBreathing): {
        _respirationRate = 0;
    };
    case ([_unit] call EFUNC(core,bvmActive)): {
        _respirationRate = 10;
    };
    case ([_unit] call EFUNC(core,cprActive)): {
        _respirationRate = random [20,25,30];
    };
    case !(alive _unit);
    case (GET_HEART_RATE(_unit) < 20): {
        _respirationRate = 0;
    };
    default {
        private _desiredRespirationRate = ACM_TARGETVITALS_RR(_unit);
        private _coEffect = 1;

        private _targetRespirationRate = _desiredRespirationRate;
        
        if (_coSensitivityAdjustment != 0) then {
            _coEffect = (1 + _coSensitivityAdjustment) ^ 2;
            _targetRespirationRate = _targetRespirationRate * _coEffect ^ 4;
        };

        _targetRespirationRate = _targetRespirationRate + ((ACM_TARGETVITALS_OXYGEN(_unit) * _coEffect) - _oxygenSaturation) max (_oxygenDemand * -500);

        if IS_UNCONSCIOUS(_unit) then {
            _targetRespirationRate = (_desiredRespirationRate + 16) min _targetRespirationRate;
        };

        _targetRespirationRate = 60 min (_targetRespirationRate + _respirationRateAdjustment) max 0;

        private _respirationRateChange = (_targetRespirationRate - _respirationRate) / 2;

        if (_respirationRateChange < 0) then {
            _respirationRate = (_respirationRate + _deltaT * _respirationRateChange) max _targetRespirationRate;
        } else {
            _respirationRate = (_respirationRate + _deltaT * _respirationRateChange) min _targetRespirationRate;
        };
    };
};

_unit setVariable [QGVAR(RespirationRate), _respirationRate, _syncValue];

_respirationRate;