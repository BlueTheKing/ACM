#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Update the heart rate
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 * 1: Heart Rate Adjustments <NUMBER>
 * 2: Time since last update <NUMBER>
 * 3: Sync value? <BOOL>
 *
 * ReturnValue:
 * Current Heart Rate <NUMBER>
 *
 * Example:
 * [player, 0, 1, false] call ace_medical_vitals_fnc_updateHeartRate
 *
 * Public: No
 */

params ["_unit", "_hrTargetAdjustment", "_deltaT", "_syncValue"];

private _desiredHR = ACM_TARGETVITALS_HR(_unit);
private _heartRate = GET_HEART_RATE(_unit);

if (IN_CRDC_ARRST(_unit) || alive (_unit getVariable [QACEGVAR(medical,CPR_provider), objNull]) || [_unit] call EFUNC(circulation,recentAEDShock)) then {
    if (alive (_unit getVariable [QACEGVAR(medical,CPR_provider), objNull])) then {
        if (_heartRate == 0) then { _syncValue = true }; // always sync on large change
        _heartRate = random [100, 110, 120];
    } else {
        if (_heartRate != 0) then { _syncValue = true }; // always sync on large change
        _heartRate = 0
    };
} else {
    private _hrChange = 0;
    private _targetHR = 0;
    private _bloodVolume = GET_BLOOD_VOLUME(_unit);
    private _oxygenSaturation = GET_OXYGEN(_unit);
    if (_bloodVolume > BLOOD_VOLUME_CLASS_4_HEMORRHAGE) then {
        private _timeSinceROSC = (CBA_missionTime - (_unit getVariable [QEGVAR(circulation,ROSC_Time), -45]));
        
        GET_BLOOD_PRESSURE(_unit) params ["_bloodPressureL", "_bloodPressureH"];
        private _meanBP = (2/3) * _bloodPressureH + (1/3) * _bloodPressureL;
        private _painLevel = GET_PAIN_PERCEIVED(_unit);

        _targetHR = _desiredHR;
        if (_bloodVolume <= BLOOD_VOLUME_CLASS_3_HEMORRHAGE) then {
            private _targetBP = 105 * (_bloodVolume / DEFAULT_BLOOD_VOLUME);
            _targetHR = _heartRate * (_targetBP / (45 max _meanBP));
        };
        if (_painLevel > 0.2) then {
            if !(IS_UNCONSCIOUS(_unit)) then {
                _targetHR = _targetHR max (_desiredHR + 50 * _painLevel);
            } else {
                _targetHR = _targetHR max (_desiredHR + 40 * _painLevel);
            };
        };
        // Increase HR to compensate for low blood oxygen/higher oxygen demand (e.g. running, recovering from sprint)
        private _oxygenDemand = _unit getVariable [VAR_OXYGEN_DEMAND, 0];
        private _missingOxygen = (ACM_TARGETVITALS_OXYGEN(_unit) - _oxygenSaturation);
        private _targetOxygenHR = _targetHR + ((_missingOxygen * (linearConversion [5, 20, _missingOxygen, 0, 3.7, true])) max (_oxygenDemand * -2000));
        _targetOxygenHR = _targetOxygenHR min ACM_TARGETVITALS_MAXHR(_unit);

        _targetHR = _targetHR max _targetOxygenHR;

        _targetHR = (_targetHR + _hrTargetAdjustment) max 0;

        if (_timeSinceROSC < 45) then {
            _targetHR = _targetHR max (_desiredHR + 105 * ((30 / _timeSinceROSC) min 1));
            _targetHR = _targetHR min ACM_TARGETVITALS_MAXHR(_unit);
        } else {
            if (_unit getVariable [QEGVAR(circulation,Hardcore_PostCardiacArrest), false]) then {
                _targetHR = _targetHR min (_targetHR / _desiredHR) * (_desiredHR * 0.7);
            };
        };

        _hrChange = round(_targetHR - _heartRate) / 2;
    } else {
        _hrChange = -round(_heartRate / 10);
    };
    if (_hrChange < 0) then {
        _heartRate = (_heartRate + _deltaT * _hrChange) max _targetHR;
    } else {
        _heartRate = (_heartRate + _deltaT * _hrChange) min _targetHR;
    };
};

_unit setVariable [VAR_HEART_RATE, _heartRate, _syncValue];

_heartRate