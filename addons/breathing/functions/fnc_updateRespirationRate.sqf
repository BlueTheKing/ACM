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

params ["_unit", "_oxygenSaturation", ["_oxygenDemand", 0], "_respirationRateAdjustment", "_coSensitivityAdjustment", "_deltaT", "_syncValue"];
// 12-20 per min          40-60 per min

private _respirationRate = _unit getVariable [QGVAR(RespirationRate), 0];
private _isBreathing = (GET_AIRWAYSTATE(_unit) > 0) && (GET_BREATHINGSTATE(_unit) > 0);

switch (true) do {
    case !(_isBreathing): {
        _respirationRate = 0;
    };
    case (_unit getVariable [QACEGVAR(medical,CPR_provider), objNull]): {
        _respirationRate = random [20,25,30];
    };
    case !(alive _unit);
    case (GET_HEART_RATE(_unit) < 20): {
        _respirationRate = 0;
    };
    default {
        private _desiredRespirationRate = ACM_TARGETVITALS_RR(_unit);

        private _targetRespirationRate = _desiredRespirationRate  * (1 + _coSensitivityAdjustment);

        _targetRespirationRate = _targetRespirationRate + (((ACM_TARGETVITALS_OXYGEN(_unit) * (1 + _coSensitivityAdjustment)) - _oxygenSaturation) * 1.1) max (_oxygenDemand * -500);

        if (_respirationRateAdjustment != 0) then {
            if (_respirationRateAdjustment < 0) then {
                _targetRespirationRate = (_targetRespirationRate + (_respirationRateAdjustment * (_targetRespirationRate / ACM_TARGETVITALS_RR(_unit)))) max 0;
            } else {
                _targetRespirationRate = (_targetRespirationRate + (_respirationRateAdjustment * (ACM_TARGETVITALS_RR(_unit) / _targetRespirationRate))) max 0;
            };
        };

        private _respirationRateChange = (_targetRespirationRate - _respirationRate) / 2;

        if (_respirationRateChange < 0) then {
            _respirationRate = (_respirationRate + _deltaT * _respirationRateChange) max 0;
        } else {
            _respirationRate = (_respirationRate + _deltaT * _respirationRateChange) min 60;
        };
    };
};

_unit setVariable [QGVAR(RespirationRate), _respirationRate, _syncValue];

_respirationRate;