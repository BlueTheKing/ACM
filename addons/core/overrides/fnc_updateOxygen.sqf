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

params ["_unit", "_respirationRateAdjustment", "_coSensitivityAdjustment", "_breathingEffectivenessAdjustment", "_deltaT", "_syncValue"];

//if (!ACEGVAR(medical_vitals,simulateSpO2)) exitWith {}; // changing back to default is handled in initSettings.inc.sqf

private _desiredOxygenSaturation = ACM_TARGETVITALS_OXYGEN(_unit);

#define IDEAL_PPO2 0.255

private _currentOxygenSaturation = GET_OXYGEN(_unit);
private _heartRate = GET_HEART_RATE(_unit);

private _altitude = ACEGVAR(common,mapAltitude) + ((getPosASL _unit) select 2);
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
    [goggles _unit, headgear _unit, vest _unit] findIf {
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

if (_unit == ACE_player && {missionNamespace getVariable [QACEGVAR(advanced_fatigue,enabled), false]}) then {
    _negativeChange = _negativeChange - ((1 - ACEGVAR(advanced_fatigue,aeReservePercentage)) * 0.1) - ((1 - ACEGVAR(advanced_fatigue,anReservePercentage)) * 0.05);
};

private _respirationRate = [_unit, _currentOxygenSaturation, (_negativeChange - BASE_OXYGEN_USE), _respirationRateAdjustment, _coSensitivityAdjustment, _deltaT, _syncValue] call EFUNC(breathing,updateRespirationRate);

private _targetOxygenSaturation = _desiredOxygenSaturation;

// Effectiveness of capturing oxygen
// increases slightly as po2 starts lowering
// but falls off quickly as po2 drops further
private _capture = 1 max ((_po2 / IDEAL_PPO2) ^ (-_po2 * 3));

private _effectiveBloodVolume = ((sin (deg ((GET_EFF_BLOOD_VOLUME(_unit) ^ 2) / 21.1))) * 1.01) min 1;
private _airwayState = GET_AIRWAYSTATE(_unit);
private _breathingState = GET_BREATHINGSTATE(_unit);

private _oxygenSaturation = _currentOxygenSaturation;
private _oxygenChange = 0;

private _activeBVM = [_unit] call EFUNC(core,bvmActive);
private _BVMOxygenAssisted = _unit getVariable [QEGVAR(breathing,BVM_ConnectedOxygen), false];

private _timeSinceLastBreath = CBA_missionTime - (_unit getVariable [QEGVAR(breathing,BVM_lastBreath), -1]);

private _BVMLastingEffect = 0;

if (_timeSinceLastBreath < 35) then {
    _BVMLastingEffect = 1 min 15 / (_timeSinceLastBreath max 0.001);
};

private _maxDecrease = -ACM_BREATHING_MAXDECREASE;
private _maxPositiveGain = 0.5;

if !(_activeBVM) then {
    if IS_UNCONSCIOUS(_unit) then {
        _maxPositiveGain = _maxPositiveGain * 0.25;
    };
    _maxDecrease = _maxDecrease * (1 - (0.5 * _BVMLastingEffect));
} else {
    if (_BVMOxygenAssisted) then {
        _maxPositiveGain = _maxPositiveGain * 0.85;
        if (IN_CRDC_ARRST(_unit)) then {
            _maxDecrease = _maxDecrease * 0.3;
        } else {
            _maxDecrease = _maxDecrease * 0.1;
        };
    } else {
        _maxPositiveGain = _maxPositiveGain * 0.7;
        if (IN_CRDC_ARRST(_unit)) then {
            _maxDecrease = _maxDecrease * 0.9;
        } else {
            _maxDecrease = _maxDecrease * 0.7;
        };
    };
};

if (_respirationRate > 0 && (GET_HEART_RATE(_unit) > 20)) then {
    private _airSaturation = _airOxygenSaturation * _capture;

    private _hyperVentilationEffect = 0.8 max (35 / _respirationRate) min 1;
    private _breathingEffectiveness = _effectiveBloodVolume min _airwayState * _breathingState * _hyperVentilationEffect;

    if (_activeBVM) then {
        if (IN_CRDC_ARRST(_unit)) then {
            _breathingEffectiveness = _breathingEffectiveness * 1.2;
        } else {
            _breathingEffectiveness = _breathingEffectiveness * 1.9;
        };
        
        if (_BVMOxygenAssisted) then {
            _breathingEffectiveness = _breathingEffectiveness * 1.5;
        };
    } else {
        if (IN_CRDC_ARRST(_unit) && [_unit] call EFUNC(core,cprActive)) then {
            _maxPositiveGain = _maxPositiveGain * (0.5 + (0.5 * _BVMLastingEffect));
            _breathingEffectiveness = _breathingEffectiveness * 0.8 * (1 + (0.2 * _BVMLastingEffect));
        };
    };

    if (_breathingEffectivenessAdjustment != 0) then {
        _breathingEffectiveness = (_breathingEffectiveness * (1 + _breathingEffectivenessAdjustment)) min ((_breathingEffectiveness + 0.01) min 1);
    };

    private _fatigueEffect = 0.99 max (-0.25 / _negativeChange) min 1;

    private _respirationEffect = 1;

    if (_respirationRate > ACM_TARGETVITALS_RR(_unit)) then {
        _respirationEffect = 0.9 max (35 / _respirationRate) min 1.1;
    } else {
        _respirationEffect = 0.8 max (_respirationRate / 12) min 1.1;
    };

    _targetOxygenSaturation = _desiredOxygenSaturation min (_targetOxygenSaturation * _breathingEffectiveness * _airSaturation * _respirationEffect * _fatigueEffect);

    _oxygenChange = (_targetOxygenSaturation - _currentOxygenSaturation) / 5;

    if (_oxygenChange < 0) then {
        _oxygenSaturation = _currentOxygenSaturation + (_oxygenChange max _maxDecrease) * _deltaT;
    } else {
        _oxygenSaturation = _currentOxygenSaturation + ((_maxPositiveGain / 2) max _oxygenChange min _maxPositiveGain) * _deltaT;
    };
} else {
    _targetOxygenSaturation = 0;
    _oxygenSaturation = _currentOxygenSaturation + _maxDecrease * _deltaT;
};

_oxygenSaturation = 100 min _oxygenSaturation max 0;

_unit setVariable [VAR_OXYGEN_DEMAND, _negativeChange - BASE_OXYGEN_USE];
_unit setVariable [VAR_SPO2, _oxygenSaturation, _syncValue];

_oxygenSaturation;