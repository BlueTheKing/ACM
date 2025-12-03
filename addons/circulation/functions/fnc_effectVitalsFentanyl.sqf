#include "..\script_component.hpp"
/*
 * Author: Blue
 * Fentanyl medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Resistance>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsFentanyl;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Fentanyl", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
private _concentrationIM = [_patient, "Fentanyl", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration);
private _concentrationBUCC = [_patient, "Fentanyl", [ACM_ROUTE_BUCC]] call FUNC(getMedicationConcentration);
private _concentrationTotal = _concentrationIV + _concentrationIM + _concentrationBUCC;

private _weight = GET_BODYWEIGHT(_patient);

private _desiredDoseLow = 0.5 * _weight;
private _desiredDoseHigh = 1 * _weight;

private _effectIV_painSuppression = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, 0.6, true]),
    ((linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, 0.6, 1]) min 1)
] select (_concentrationIV > _desiredDoseLow);

private _effectIM_painSuppression = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIM, 0, 0.5, true]),
    ((linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, 0.5, 0.99]) min 1)
] select (_concentrationIM > _desiredDoseLow);

private _effectIV_HR = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -2, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -2, -5])
] select (_concentrationIV > _desiredDoseLow);

private _effectIM_HR = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIM, 0, -0.5, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, -0.5, -3])
] select (_concentrationIM > _desiredDoseLow);

private _effectIV_peripheralResistance = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -4, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -4, -8])
] select (_concentrationIV > _desiredDoseLow);

private _effectIM_peripheralResistance = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIM, 0, -1, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, -1, -4])
] select (_concentrationIM > _desiredDoseLow);

private _effectIV_COSensitivity = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -0.05, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -0.05, -0.06])
] select (_concentrationIV > _desiredDoseLow);

private _effectIM_COSensitivity = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIM, 0, -0.05, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, -0.05, -0.06])
] select (_concentrationIM > _desiredDoseLow);

private _desiredDoseLow_BUCC = 300;
private _desiredDoseHigh_BUCC = 600;

private _effectBUCC_painSuppression = [
    (linearConversion [_minimumConcentration, _desiredDoseLow_BUCC, _concentrationBUCC, 0, 0.5, true]),
    ((linearConversion [_desiredDoseLow_BUCC, _desiredDoseHigh_BUCC, _concentrationBUCC, 0.5, 1]) min 1)
] select (_concentrationBUCC > _desiredDoseLow_BUCC);

private _effectBUCC_HR = [
    (linearConversion [_minimumConcentration, _desiredDoseLow_BUCC, _concentrationBUCC, 0, -0.5, true]),
    (linearConversion [_desiredDoseLow_BUCC, _desiredDoseHigh_BUCC, _concentrationBUCC, -0.5, -3])
] select (_concentrationBUCC > _desiredDoseLow_BUCC);

private _effectBUCC_peripheralResistance = [
    (linearConversion [_minimumConcentration, _desiredDoseLow_BUCC, _concentrationBUCC, 0, -4, true]),
    (linearConversion [_desiredDoseLow_BUCC, _desiredDoseHigh_BUCC, _concentrationBUCC, -1, -4])
] select (_concentrationBUCC > _desiredDoseLow_BUCC);

private _effectBUCC_COSensitivity = [
    (linearConversion [_minimumConcentration, _desiredDoseLow_BUCC, _concentrationBUCC, 0, -0.06, true]),
    (linearConversion [_desiredDoseLow_BUCC, _desiredDoseHigh_BUCC, _concentrationBUCC, -0.06, -0.07])
] select (_concentrationBUCC > _desiredDoseLow_BUCC);

private _antagonistDose = GET_OPIOID_ANTAGONIST_DOSE(_patient);
private _blockEffect = (((_concentrationTotal - ([(linearConversion [0, 4, _antagonistDose, 0, 200, true]), (linearConversion [4, 10, _antagonistDose, 200, 500, true])] select (_antagonistDose > 4))) max 0) / _concentrationTotal);

[
    (((_effectIV_painSuppression max _effectIM_painSuppression max _effectBUCC_painSuppression) max ((_effectIV_painSuppression min 0.6) + (_effectIM_painSuppression min 0.4) + (_effectBUCC_painSuppression min 0.5))) min 1) * _blockEffect,
    ([(_effectIV_HR + _effectIM_HR + _effectBUCC_HR),(_effectIV_HR min _effectIM_HR min _effectBUCC_HR)] select (_concentrationTotal > 130)) * _blockEffect,
    ([(_effectIV_peripheralResistance + _effectIM_peripheralResistance + _effectBUCC_peripheralResistance),(_effectIV_peripheralResistance min _effectIM_peripheralResistance min _effectBUCC_peripheralResistance)] select (_concentrationTotal > 130)) * _blockEffect,
    0,
    ([(_effectIV_COSensitivity + _effectIM_COSensitivity + _effectBUCC_COSensitivity),(_effectIV_COSensitivity min _effectIM_COSensitivity min _effectBUCC_COSensitivity)] select (_concentrationTotal > 130)) * _blockEffect,
    0
];