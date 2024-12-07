#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Calculate the blood pressure of a unit.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * Return Value:
 * 0: BloodPressure Low <NUMBER>
 * 1: BloodPressure High <NUMBER>
 *
 * Example:
 * [player] call ace_medical_status_fnc_getBloodPressure
 *
 * Public: No
 */

// Value is taken because with cardic output and resistance at default values, it will put blood pressure High at 120.
#define MODIFIER_BP_HIGH    9.4736842

// Value is taken because with cardic output and resistance at default values, it will put blood pressure Low at 80.
#define MODIFIER_BP_LOW     6.3157894

params ["_unit"];

private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);
private _resistance = _unit getVariable [VAR_PERIPH_RES, DEFAULT_PERIPH_RES];
private _bloodPressure = _cardiacOutput * _resistance;

private _HR = GET_HEART_RATE(_unit);

if (_HR > 140) then {
    _bloodPressure = _bloodPressure * (linearConversion [140, 200, _HR, 1, 0.75, true]);
};

private _bloodVolume = GET_BLOOD_VOLUME(_unit);

if (_bloodVolume < 4.8) then {
    _bloodPressure = _bloodPressure * (linearConversion [4.8, 3.6, _bloodVolume, 1, 0.5, true]);
};

private _bleedEffect = 1 - (0.2 * GET_WOUND_BLEEDING(_unit)); // Lower blood pressure if person is actively bleeding
private _hemothoraxBleeding = 0.4 * ((_unit getVariable [QEGVAR(breathing,Hemothorax_State), 0]) / 4);
private _internalBleedingEffect = 1 min (1 - (0.8 * (GET_INTERNAL_BLEEDING(_unit) + _hemothoraxBleeding))) max 0.5; // Lower blood pressure if person has uncontrolled internal bleeding

private _tensionEffect = 0;

private _HTXFluid = _unit getVariable [QEGVAR(breathing,Hemothorax_Fluid), 0];
private _PTXState = _unit getVariable [QEGVAR(breathing,Pneumothorax_State), 0];

private _overloadEffect = linearConversion [0, 1, (_unit getVariable [QEGVAR(circulation,Overload_Volume), 0]), 1, 1.3];

private _diastolicModifier = 1;

if (GET_BLOOD_VOLUME(_unit) < DEFAULT_BLOOD_VOLUME) then {
    _diastolicModifier = linearConversion [BLOOD_VOLUME_CLASS_2_HEMORRHAGE, BLOOD_VOLUME_CLASS_3_HEMORRHAGE, GET_BLOOD_VOLUME(_unit), 1, 1.2, true];
};

if (_PTXState > 0 || _HTXFluid > 0.1) then {
    _tensionEffect = (_PTXState * 8) max (_HTXFluid / 46);
};

if ((_unit getVariable [QEGVAR(breathing,TensionPneumothorax_State), false]) || (_unit getVariable [QEGVAR(breathing,Hardcore_Pneumothorax), false])) then {
    _tensionEffect = 35;
};

[(round(((_bloodPressure * MODIFIER_BP_LOW * _diastolicModifier) - _tensionEffect) * _bleedEffect * _internalBleedingEffect * _overloadEffect)) max 0, (round(((_bloodPressure * MODIFIER_BP_HIGH) - _tensionEffect) * _bleedEffect * _internalBleedingEffect * _overloadEffect)) max 0]