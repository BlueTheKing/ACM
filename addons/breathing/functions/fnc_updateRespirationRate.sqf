#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update respiration rate
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Heart Rate <NUMBER>
 * 2: Oxygen Demand <NUMBER>
 * 3: Time since last update <NUMBER>
 * 4: Sync value? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 80, -0.25 1, false] call ACM_breathing_fnc_updateRespirationRate;
 *
 * Public: No
 */

params ["_unit", "_heartRate", ["_oxygenDemand", 0], "_deltaT", "_syncValue"];
// 12-20 per min          40-60 per min

private _respirationRate = _unit getVariable [QGVAR(RespirationRate), 0];
private _isBreathing = (_unit getVariable [QEGVAR(airway,AirwayState), 1] > 0) && (_unit getVariable [QGVAR(BreathingState), 1] > 0);

switch (true) do {
    case !(_isBreathing): {
        _respirationRate = 0;
    };
    case (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull]): {
        _respirationRate = random [10,11,12];
    };
    case !(alive _patient);
    case (IN_CRDC_ARRST(_patient)): {
        _respirationRate = 0;
    };
    default {
        private _desiredRespirationRate = _unit getVariable [QEGVAR(core,TargetVitals_RespirationRate), 16];

        private _targetRespirationRate = _desiredRespirationRate;

        _targetRespirationRate = linearConversion [-0.25, -0.3, _oxygenDemand, _desiredRespirationRate, 50, false];
        _targetRespirationRate = _targetRespirationRate * (_heartRate / (_unit getVariable [QEGVAR(core,TargetVitals_HeartRate), 80]));

        private _respirationRateChange = (_targetRespirationRate - _respirationRate) / 2;

        _respirationRate = (_respirationRate + _respirationRateChange * _deltaT) min 60;
    };
};

_unit setVariable [QGVAR(RespirationRate), _respirationRate, _syncValue];