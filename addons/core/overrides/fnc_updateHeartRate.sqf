#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Update the heart rate
 *
 * Arguments:
 * 0: Patient <OBJECT>
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

params ["_patient", "_hrTargetAdjustment", "_deltaT", "_syncValue"];

private _desiredHR = ACM_TARGETVITALS_HR(_patient);
private _heartRate = GET_HEART_RATE(_patient);

if (IN_CRDC_ARRST(_patient) || [_patient] call FUNC(cprActive)) then {
    if ([_patient] call FUNC(cprActive)) then {
        if (_heartRate == 0) then { _syncValue = true }; // always sync on large change
        _heartRate = random [100, 110, 120];
    } else {
        if (_heartRate != 0) then { _syncValue = true }; // always sync on large change
        _heartRate = 0
    };
} else {
    private _hrChange = 0;
    private _targetHR = 0;
    private _bloodVolume = GET_BLOOD_VOLUME(_patient);
    private _oxygenSaturation = GET_OXYGEN(_patient);

    if (_bloodVolume > BLOOD_VOLUME_CLASS_4_HEMORRHAGE) then {
        private _timeSinceROSC = (CBA_missionTime - (_patient getVariable [QEGVAR(circulation,ROSC_Time), -120]));

        private _MAP = GET_MAP_PATIENT(_patient);
        private _painLevel = GET_PAIN_PERCEIVED(_patient);

        _targetHR = _desiredHR;

        if (_bloodVolume <= BLOOD_VOLUME_CLASS_2_HEMORRHAGE) then {
            _targetHR = _targetHR * (linearConversion [90, 60, (100 min _MAP), 1, 2]);

            if (_bloodVolume < 4) then {
                _targetHR = linearConversion [4, BLOOD_VOLUME_CLASS_4_HEMORRHAGE, _bloodVolume, (_desiredHR * 1.7), (_desiredHR * 2.4)];
            }; 
        };

        if (_painLevel > 0.2) then {
            _targetHR = _targetHR max (_desiredHR + 50 * _painLevel);
        };

        _targetHR = _targetHR min ACM_TARGETVITALS_MAXHR(_patient);

        // Increase HR to compensate for low blood oxygen/higher oxygen demand (e.g. running, recovering from sprint)
        private _oxygenDemand = _patient getVariable [VAR_OXYGEN_DEMAND, 0];
        private _missingOxygen = (ACM_TARGETVITALS_OXYGEN(_patient) - _oxygenSaturation);
        private _targetOxygenHR = _targetHR + ((_missingOxygen * (linearConversion [5, 20, _missingOxygen, 0, 2, true])) max (_oxygenDemand * -2000));
        _targetOxygenHR = _targetOxygenHR min ACM_TARGETVITALS_MAXHR(_patient);

        _targetHR = _targetHR max _targetOxygenHR;

        _targetHR = (_targetHR + _hrTargetAdjustment) max 0;

        _targetHR = _targetHR * (linearConversion [55, 90, GET_HEART_FATIGUE(_patient), 1, 0.1, true]);

        if (_timeSinceROSC < 120) then {
            _targetHR = _targetHR - ((linearConversion [50, ACM_TARGETVITALS_MAXHR(_patient), _targetHR, 0, 150, true]) * (linearConversion [0, 120, _timeSinceROSC, 1, 0, true]));
        } else {
            if (_patient getVariable [QEGVAR(circulation,Hardcore_PostCardiacArrest), false]) then {
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

private _heartFatigue = GET_HEART_FATIGUE(_patient);

if (_heartFatigue > 0 || _heartRate > 135 || _oxygenSaturation < 90) then {
    private _effectiveBloodVolume = GET_EFF_BLOOD_VOLUME(_patient);
    private _heartFatigueChange = (-((linearConversion [130, ACM_TARGETVITALS_HR(_patient), _heartRate, 0, 0.2, true]) + (linearConversion [90, 99, _oxygenSaturation, 0, 0.2, true]))) * (linearConversion [3, 6, _effectiveBloodVolume, 0, 2, true]);

    if (_heartRate > 135 || (_oxygenSaturation < 90 && _heartRate > 0)) then {
        _heartFatigueChange = _heartFatigueChange + ((linearConversion [135, ACM_TARGETVITALS_MAXHR(_patient), _heartRate, 0, 0.15, true]) + (linearConversion [90, 75, _oxygenSaturation, 0, 0.15, true])) * (linearConversion [5.5, 3, _effectiveBloodVolume, 1, 2, true]);
    };

    _heartFatigue = 0 max (_heartFatigue + _heartFatigueChange * _deltaT) min 100;
    _patient setVariable [QEGVAR(circulation,HeartFatigue_State), _heartFatigue, _syncValue];
};

_patient setVariable [VAR_HEART_RATE, _heartRate, _syncValue];

_heartRate