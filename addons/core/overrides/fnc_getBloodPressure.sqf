#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Calculate the blood pressure of a unit.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * 0: Diastolic <NUMBER>
 * 1: Systolic <NUMBER>
 *
 * Example:
 * [player] call ace_medical_status_fnc_getBloodPressure
 *
 * Public: No
 */

// 120/80 @ 80bpm
#define MODIFIER_BP_SYSTOLIC 9.4736842
#define MODIFIER_BP_DIASTOLIC 6.3157894

params ["_patient"];

private _cardiacOutput = [_patient] call ACEFUNC(medical_status,getCardiacOutput);

private _vasoconstriction = GET_VASOCONSTRICTION(_patient);

private _resistance = ([
    ([(linearConversion [0, -30, _vasoconstriction, 1, 0.7, true]), (linearConversion [-30, -50, _vasoconstriction, 0.7, 0.6, true])] select (_vasoconstriction < -30)),
    ([(linearConversion [0, 30, _vasoconstriction, 1, 1.4, true]), (linearConversion [30, 50, _vasoconstriction, 1.4, 1.6, true])] select (_vasoconstriction > 30))
] select (_vasoconstriction > 0));

private _bloodPressure = _cardiacOutput * _resistance * 100;

private _bleedEffect = 1 - (0.2 * GET_WOUND_BLEEDING(_patient)); // Lower blood pressure if person is actively bleeding
private _hemothoraxBleeding = 0.5 * ((_patient getVariable [QEGVAR(breathing,Hemothorax_State), 0]) / 10);
private _internalBleedingEffect = 1 min (1 - (0.8 * (GET_INTERNAL_BLEEDING(_patient) + _hemothoraxBleeding))) max 0.5; // Lower blood pressure if person has uncontrolled internal bleeding

private _tensionEffect = 0;

private _HTXFluid = _patient getVariable [QEGVAR(breathing,Hemothorax_Fluid), 0];
private _PTXState = _patient getVariable [QEGVAR(breathing,Pneumothorax_State), 0];

private _overloadEffect = linearConversion [0, 1, (_patient getVariable [QEGVAR(circulation,Overload_Volume), 0]), 1, 2];

private _poisonEffect = 1;

if (EGVAR(CBRN,enable)) then {
    _poisonEffect = linearConversion [0, 100, GET_CAPILLARY_DAMAGE(_patient), 1, 0.7];
};

private _diastolicModifier = 1;

if (GET_BLOOD_VOLUME(_patient) < DEFAULT_BLOOD_VOLUME) then {
    _diastolicModifier = linearConversion [BLOOD_VOLUME_CLASS_2_HEMORRHAGE, BLOOD_VOLUME_CLASS_3_HEMORRHAGE, GET_BLOOD_VOLUME(_patient), 1, 1.2, true];
};

if (_PTXState > 0 || _HTXFluid > 0.1) then {
    _tensionEffect = (_PTXState * 8) max (_HTXFluid / 46);
};

if ((_patient getVariable [QEGVAR(breathing,TensionPneumothorax_State), false]) || (_patient getVariable [QEGVAR(breathing,Hardcore_Pneumothorax), false])) then {
    _tensionEffect = 35;
};

[(round(((_bloodPressure * MODIFIER_BP_DIASTOLIC * _diastolicModifier) - _tensionEffect) * _bleedEffect * _internalBleedingEffect * _overloadEffect * _poisonEffect)) max 0, (round(((_bloodPressure * MODIFIER_BP_SYSTOLIC) - _tensionEffect) * _bleedEffect * _internalBleedingEffect * _overloadEffect * _poisonEffect)) max 0]