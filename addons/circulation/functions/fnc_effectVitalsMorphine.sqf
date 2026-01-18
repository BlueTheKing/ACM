#include "..\script_component.hpp"
/*
 * Author: Blue
 * Morphine medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Vasoconstriction Adjustment>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsMorphine;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Morphine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
private _concentrationIM = [_patient, "Morphine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration);
private _concentrationTotal = _concentrationIV + _concentrationIM;

private _weight = GET_BODYWEIGHT(_patient);

private _desiredDoseLow = 0.05 * _weight;
private _desiredDoseHigh = 0.1 * _weight;

private _effectIV_painSuppression = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, 0.5, true]),
    ((linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, 0.5, 0.95]) min 1)
] select (_concentrationIV > _desiredDoseLow);

private _effectIM_painSuppression = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIM, 0, 0.4, true]),
    ((linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, 0.4, 0.9]) min 0.95)
] select (_concentrationIM > _desiredDoseLow);

private _effectIV_HR = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -8, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -8, -15])
] select (_concentrationIV > _desiredDoseLow);

private _effectIM_HR = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIM, 0, -6, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, -6, -12])
] select (_concentrationIM > _desiredDoseLow);

private _effectIV_peripheralVasoconstriction = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -12, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -12, -22])
] select (_concentrationIV > _desiredDoseLow);

private _effectIM_peripheralVasoconstriction = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIM, 0, -7, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, -7, -16])
] select (_concentrationIM > _desiredDoseLow);

private _effectIV_COSensitivity = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -0.05, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -0.05, -0.08])
] select (_concentrationIV > _desiredDoseLow);

private _effectIM_COSensitivity = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIM, 0, -0.05, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, -0.05, -0.08])
] select (_concentrationIM > _desiredDoseLow);

private _antagonistDose = GET_OPIOID_ANTAGONIST_DOSE(_patient);
private _blockEffect = (((_concentrationTotal - ([(linearConversion [0, 4, _antagonistDose, 0, 20, true]), (linearConversion [4, 10, _antagonistDose, 20, 50, true])] select (_antagonistDose > 4))) max 0) / _concentrationTotal);

[
    (((_effectIV_painSuppression max _effectIM_painSuppression) max ((_effectIV_painSuppression min 0.6) + (_effectIM_painSuppression min 0.4))) min 1) * _blockEffect,
    ([(_effectIV_HR + _effectIM_HR),(_effectIV_HR min _effectIM_HR)] select (_concentrationTotal > 5)) * _blockEffect,
    ([(_effectIV_peripheralVasoconstriction + _effectIM_peripheralVasoconstriction),(_effectIV_peripheralVasoconstriction min _effectIM_peripheralVasoconstriction)] select (_concentrationTotal > 5)) * _blockEffect,
    0,
    ([(_effectIV_COSensitivity + _effectIM_COSensitivity),(_effectIV_COSensitivity min _effectIM_COSensitivity)] select (_concentrationTotal > 5)) * _blockEffect,
    0
];
