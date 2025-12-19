#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get heart rate as generated from EKG
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * EKG Heart Rate <NUMBER>
 *
 * Example:
 * [player] call ACM_circulation_fnc_getEKGHeartRate;
 *
 * Public: No
 */

params ["_patient"];

private _fnc_generateHeartRate = { // ace_medical_vitals_fnc_updateHeartRate
    params ["_patient"];

    private _lastTimeUpdated = _patient getVariable [QACEGVAR(medical_vitals,lastTimeUpdated), 0];
    private _deltaT = (CBA_missionTime - _lastTimeUpdated) min 10;
    if (_deltaT < 1) exitWith {_patient getVariable [QGVAR(CardiacArrest_EKG_HR), (ACM_TARGETVITALS_HR(_patient))]};

    private _desiredHR = ACM_TARGETVITALS_HR(_patient);

    private _heartRate = _patient getVariable [QGVAR(CardiacArrest_EKG_HR), _desiredHR];

    private _hrChange = 0;
    private _bloodVolume = GET_BLOOD_VOLUME(_patient);
    private _targetHR = linearConversion [DEFAULT_BLOOD_VOLUME, BLOOD_VOLUME_CLASS_2_HEMORRHAGE, _bloodVolume, _desiredHR, (_desiredHR + 35)];
    
    private _oxygenSaturation = GET_OXYGEN(_patient);
    private _painLevel = GET_PAIN_PERCEIVED(_patient);

    if (_bloodVolume <= BLOOD_VOLUME_CLASS_2_HEMORRHAGE && _bloodVolume > BLOOD_VOLUME_CLASS_3_HEMORRHAGE) then {
        _targetHR = linearConversion [BLOOD_VOLUME_CLASS_2_HEMORRHAGE, BLOOD_VOLUME_CLASS_3_HEMORRHAGE, _bloodVolume, _desiredHR, (_desiredHR * 1.7)];
    };
    if (_bloodVolume <= BLOOD_VOLUME_CLASS_3_HEMORRHAGE) then {
        _targetHR = linearConversion [4, BLOOD_VOLUME_CLASS_4_HEMORRHAGE, _bloodVolume, (_desiredHR * 1.7), (_desiredHR * 2.4)];
    };
    if (_painLevel > 0.2) then {
        _targetHR = _targetHR max (_desiredHR + 40 * _painLevel);
    };
    if (_bloodVolume > 3.9) then {
        _targetHR = _targetHR min ACM_TARGETVITALS_MAXHR(_patient);
    };
    
    // Increase HR to compensate for low blood oxygen/higher oxygen demand (e.g. running, recovering from sprint)
    private _oxygenDemand = _patient getVariable [VAR_OXYGEN_DEMAND, 0];
    private _targetOxygenHR = _targetHR + ((ACM_TARGETVITALS_OXYGEN(_patient) - _oxygenSaturation) * 2) + (_oxygenDemand * -1000);
    _targetOxygenHR = _targetOxygenHR min ACM_TARGETVITALS_MAXHR(_patient);

    _targetHR = _targetHR max _targetOxygenHR;

    if (_bloodVolume < (ACM_ASYSTOLE_BLOODVOLUME + 0.3)) then {
        _targetHR = _targetHR + 266 * (_bloodVolume - (ACM_ASYSTOLE_BLOODVOLUME + 0.3));
    };

    _hrChange = round(_targetHR - _heartRate) / 2;

    if (_hrChange < 0) then {
        _heartRate = (_heartRate + _deltaT * _hrChange) max _targetHR;
    } else {
        _heartRate = (_heartRate + _deltaT * _hrChange) min _targetHR;
    };

    _heartRate = _heartRate max 30;

    _patient setVariable [QGVAR(CardiacArrest_EKG_HR), _heartRate];

    _heartRate;
};

if (alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull])) exitWith {GET_HEART_RATE(_patient)};

private _rhythm = _patient getVariable [QGVAR(Cardiac_RhythmState), ACM_Rhythm_Sinus];

if ([_patient] call FUNC(recentAEDShock) || !(alive _patient)) exitWith {0};

switch (_rhythm) do {
    case ACM_Rhythm_Asystole: { // Asystole
        _patient setVariable [QGVAR(CardiacArrest_EKG_HR), 0];
        0;
    };
    case ACM_Rhythm_VF: { // Ventricular Fibrillation
        round (random [150, 170, 200]);
    };
    case ACM_Rhythm_PVT: { // (Pulseless) Ventricular Tachycardia
        round (random [200, 220, 240]);
    };
    case ACM_Rhythm_PEA: { // Pulseless Electrical Activity (Reversible)
        [_patient] call _fnc_generateHeartRate;
    };
    case ACM_Rhythm_VT;
    default { // Sinus
        private _pr = GET_HEART_RATE(_patient);
        _patient setVariable [QGVAR(CardiacArrest_EKG_HR), _pr];
        _pr;
    };
};