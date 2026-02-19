#include "..\script_component.hpp"
/*
 * Author: Brett Mayson
 * Update the oxygen levels
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 * 1: Respiration Rate Adjustment <NUMBER>
 * 2: Carbon Dioxide Sensitivity Adjustment <NUMBER>
 * 3: Breathing Effectiveness Adjustment <NUMBER>
 * 4: Time since last update <NUMBER>
 * 5: Sync value? <BOOL>
 *
 * ReturnValue:
 * Current SPO2 <NUMBER>
 *
 * Example:
 * [player, 1, false] call ace_medical_vitals_fnc_updateOxygen;
 *
 * Public: No
 */

params ["_patient", "_respirationRateAdjustment", "_coSensitivityAdjustment", "_breathingEffectivenessAdjustment", "_deltaT", "_syncValue"];

//if (!ACEGVAR(medical_vitals,simulateSpO2)) exitWith {}; // changing back to default is handled in initSettings.inc.sqf

private _desiredOxygenSaturation = ACM_TARGETVITALS_OXYGEN(_patient);

#define IDEAL_PPO2 0.255

private _currentOxygenSaturation = GET_OXYGEN(_patient);
private _heartRate = GET_HEART_RATE(_patient);

private _altitude = ACEGVAR(common,mapAltitude) + ((getPosASL _patient) select 2);
private _po2 = if (missionNamespace getVariable [QACEGVAR(weather,enabled), false]) then {
    private _temperature = _altitude call ACEFUNC(weather,calculateTemperatureAtHeight);
    private _pressure = _altitude call ACEFUNC(weather,calculateBarometricPressure);
    [_temperature, _pressure, ACEGVAR(weather,currentHumidity)] call ACEFUNC(weather,calculateOxygenDensity)
} else {
    // Rough approximation of the partial pressure of oxygen in the air
    0.25725 * (_altitude / 1000 + 1)
};

private _airOxygenSaturation = 1;

if (EGVAR(breathing,altitudeAffectOxygen)) then {
    _airOxygenSaturation = (IDEAL_PPO2 min _po2) / IDEAL_PPO2;

    // Check gear for oxygen supply
    [goggles _patient, headgear _patient, vest _patient] findIf {
        _x in ACEGVAR(medical_vitals,oxygenSupplyConditionCache) &&
        {ACE_player call (ACEGVAR(medical_vitals,oxygenSupplyConditionCache) get _x)} &&
        { // Will only run this if other conditions are met due to lazy eval
            _airOxygenSaturation = 1;
            _po2 = IDEAL_PPO2;
            true
        }
    };
} else {
    _po2 = IDEAL_PPO2;
    _airOxygenSaturation = 1;
};

// Fatigue & exercise will demand more oxygen
// Assuming a trained male in midst of peak exercise will have a peak heart rate of ~180 BPM
// Ref: https://academic.oup.com/bjaed/article-pdf/4/6/185/894114/mkh050.pdf table 2, though we don't take stroke volume change into account
private _negativeChange = BASE_OXYGEN_USE;

if (_patient == ACE_player && {missionNamespace getVariable [QACEGVAR(advanced_fatigue,enabled), false]}) then {
    _negativeChange = _negativeChange - ((1 - ACEGVAR(advanced_fatigue,aeReservePercentage)) * 0.1) - ((1 - ACEGVAR(advanced_fatigue,anReservePercentage)) * 0.05);
};

private _respirationRate = [_patient, _currentOxygenSaturation, (_negativeChange - BASE_OXYGEN_USE), _respirationRateAdjustment, _coSensitivityAdjustment, _deltaT, _syncValue] call EFUNC(breathing,updateRespirationRate);

private _targetOxygenSaturation = _desiredOxygenSaturation;

// Effectiveness of capturing oxygen
// increases slightly as po2 starts lowering
// but falls off quickly as po2 drops further
private _capture = 1 max ((_po2 / IDEAL_PPO2) ^ (-_po2 * 3));

private _effectiveBloodVolume = [linearConversion [DEFAULT_BLOOD_VOLUME, 5, GET_EFF_BLOOD_VOLUME(_patient), 1, 0.92, true],(linearConversion [5, 4, GET_EFF_BLOOD_VOLUME(_patient), 0.92, 0.84])] select (GET_EFF_BLOOD_VOLUME(_patient) < 5);
private _airwayState = GET_AIRWAYSTATE(_patient);
private _breathingState = GET_BREATHINGSTATE(_patient);

private _oxygenSaturation = _currentOxygenSaturation;
private _oxygenChange = 0;

private _activeBVM = [_patient] call FUNC(bvmActive);
private _BVMOxygenAssisted = _patient getVariable [QEGVAR(breathing,BVM_ConnectedOxygen), false];

private _freshBloodEffectiveness = _patient getVariable [QEGVAR(circulation,IV_Bags_FreshBloodEffect), 0];

private _timeSinceLastBreath = CBA_missionTime - (_patient getVariable [QEGVAR(breathing,BVM_lastBreath), -35]);

private _BVMLastingEffect = 0;

if (_timeSinceLastBreath < 35) then {
    _BVMOxygenAssisted = (CBA_missionTime - (_patient getVariable [QEGVAR(breathing,BVM_lastBreathOxygen), -35])) < 30;
    _BVMLastingEffect = 1 min 25 / (_timeSinceLastBreath max 0.001);
};

private _maxDecrease = [-ACM_BREATHING_MINDECREASE, (linearConversion [90, 75, _oxygenSaturation, -ACM_BREATHING_MAXDECREASE, -ACM_BREATHING_MINDECREASE, true])] select (_heartRate > 0);
private _maxPositiveGain = 0.5;

if !(_activeBVM) then {
    if IS_EXPOSED(_patient) then { // CBRN
        _maxPositiveGain = _maxPositiveGain * GET_EXPOSURE_BREATHING_INCREASESTATE(_patient);
    };
    if IS_UNCONSCIOUS(_patient) then {
        _maxPositiveGain = (_maxPositiveGain) * 0.25;
    };
    _maxDecrease = _maxDecrease * (1 - (0.7 * _BVMLastingEffect));
} else {
    if (_BVMOxygenAssisted) then {
        _maxPositiveGain = _maxPositiveGain * 0.8;
        if IN_CRDC_ARRST(_patient) then {
            _maxDecrease = _maxDecrease * 0.3;
        } else {
            _maxDecrease = _maxDecrease * 0.1;
        };
    } else {
        if IS_EXPOSED(_patient) then { // CBRN
            _maxPositiveGain = _maxPositiveGain * GET_EXPOSURE_BREATHING_INCREASESTATE(_patient);
        };
        _maxPositiveGain = _maxPositiveGain * 0.75;
        if IN_CRDC_ARRST(_patient) then {
            _maxDecrease = _maxDecrease * 0.9;
        } else {
            _maxDecrease = _maxDecrease * 0.7;
        };
    };
};

if (EGVAR(CBRN,enable) && _respirationRate > 0) then {
    private _airwayInflammation = GET_AIRWAY_INFLAMMATION(_patient);

    if (!(HAS_SURGICAL_AIRWAY(_patient)) && _airwayInflammation > 30) then {
        _maxPositiveGain = _maxPositiveGain * (linearConversion [30, 100, _airwayInflammation, 1, 0, true]);
    };

    private _lungTissueDamage = GET_LUNG_TISSUEDAMAGE(_patient);

    if (_lungTissueDamage >= 100) then {
        _breathingState = 0;
    } else {
        _breathingState = _breathingState * (linearConversion [20, 95, _lungTissueDamage, 1, 0.1, true]);
    };
};

private _breathingEffectiveness = _effectiveBloodVolume min _airwayState * _breathingState;

switch (true) do {
    case (_respirationRate > 0 && HAS_PULSE(_patient)): {
        private _airSaturation = _airOxygenSaturation * _capture;
        private _cardiacEffect = 1;

        private _MAP = GET_MAP_PATIENT(_patient);

        if (_MAP > 90) then {
            _cardiacEffect = _cardiacEffect * ([(linearConversion [95, 120, _MAP, 1, 1.15, true]), (linearConversion [120, 150, _MAP, 1.15, 0.85, true])] select (_MAP > 120));
        } else {
            _cardiacEffect = _cardiacEffect * (linearConversion [80, 60, _MAP, 1, 0.8, true]);
        };

        if (_activeBVM) then {
            if (IN_CRDC_ARRST(_patient)) then {
                _breathingEffectiveness = _breathingEffectiveness * 1.2;
            } else {
                _breathingEffectiveness = _breathingEffectiveness * 1.3;
            };

            if (_BVMOxygenAssisted) then {
                _breathingEffectiveness = _breathingEffectiveness * 1.6;
            };
        };

        if (_freshBloodEffectiveness > 0.83) then {
            _breathingEffectiveness = _breathingEffectiveness * (1 max (1.2 * _freshBloodEffectiveness));
        };

        if (_breathingEffectivenessAdjustment != 0) then {
            _breathingEffectiveness = (_breathingEffectiveness * (1 + _breathingEffectivenessAdjustment)) min ((_breathingEffectiveness + 0.01) min 1);
        };

        private _fatigueEffect = 0.99 max (-0.25 / _negativeChange) min 1;

        private _respirationEffect = 1;

        if (_respirationRate > ACM_TARGETVITALS_RR(_patient)) then {
            [(1 max (_respirationRate / ACM_TARGETVITALS_RR(_patient)) min 1.3), (0.9 max (34 / _respirationRate) min 1.3)] select (_respirationRate > 30);
        } else {
            _respirationEffect = 0.8 max (_respirationRate / 12) min 1;
        };

        _targetOxygenSaturation = _desiredOxygenSaturation min (_targetOxygenSaturation * _breathingEffectiveness * _cardiacEffect * _airSaturation * _respirationEffect * _fatigueEffect);

        _oxygenChange = (_targetOxygenSaturation - _currentOxygenSaturation) / 5;

        if (_oxygenChange < 0) then {
            _oxygenSaturation = _currentOxygenSaturation + (_oxygenChange max _maxDecrease) * _deltaT;
        } else {
            _oxygenSaturation = _currentOxygenSaturation + ((_maxPositiveGain / 2) max _oxygenChange min _maxPositiveGain) * _deltaT;
        };
    };
    case (IN_CRDC_ARRST(_patient) && ([_patient] call FUNC(cprActive))): {
        _maxPositiveGain = _maxPositiveGain * (0.5 + (0.5 * _BVMLastingEffect));
        _breathingEffectiveness = _breathingEffectiveness * 0.75 * (1 + (0.3 * _BVMLastingEffect));

        if (_BVMOxygenAssisted) then {
            _breathingEffectiveness = _breathingEffectiveness * 1.5;
        };
        
        if (_breathingEffectivenessAdjustment != 0) then {
            _breathingEffectiveness = (_breathingEffectiveness * (1 + _breathingEffectivenessAdjustment)) min ((_breathingEffectiveness + 0.01) min 1);
        };

        _targetOxygenSaturation = _desiredOxygenSaturation min _targetOxygenSaturation * _breathingEffectiveness;

        _oxygenChange = (_targetOxygenSaturation - _currentOxygenSaturation) / 5;

        if (_oxygenChange < 0) then {
            _oxygenSaturation = _currentOxygenSaturation + (_oxygenChange max _maxDecrease) * _deltaT;
        } else {
            _oxygenSaturation = _currentOxygenSaturation + ((_maxPositiveGain / 10) max _oxygenChange min _maxPositiveGain) * _deltaT;
        };
    };
    default {
        _targetOxygenSaturation = 0;
        _oxygenSaturation = _currentOxygenSaturation + _maxDecrease * _deltaT;
    };
};

_oxygenSaturation = 100 min _oxygenSaturation max 0;

_patient setVariable [VAR_OXYGEN_DEMAND, _negativeChange - BASE_OXYGEN_USE];
_patient setVariable [VAR_SPO2, _oxygenSaturation, _syncValue];

_oxygenSaturation;