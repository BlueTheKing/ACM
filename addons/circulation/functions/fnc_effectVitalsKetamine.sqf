#include "..\script_component.hpp"
/*
 * Author: Blue
 * Ketamine medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Resistance>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsKetamine;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Ketamine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
private _concentrationIM = ([_patient, "Ketamine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration)) * 1.11;
private _concentrationTotal = _concentrationIV + _concentrationIM;

private _weight = GET_BODYWEIGHT(_patient);

private _analgesiaDoseLow_IV = 0.1 * _weight;
private _analgesiaDoseHigh_IV = 0.2 * _weight;

private _analgesiaDoseLow_IM = 0.4 * _weight;
private _analgesiaDoseHigh_IM = 0.8 * _weight;

private _sedationDoseLow_IV = _weight;
private _sedationDoseHigh_IV = 2 * _weight;

private _sedationDoseLow_IM = 4 * _weight;
private _sedationDoseHigh_IM = 5 * _weight;

private _effectIV_painSuppression = [
    (linearConversion [_minimumConcentration, _analgesiaDoseLow_IV, _concentrationIV, 0, 0.5, true]),
    ((linearConversion [_analgesiaDoseLow_IV, _analgesiaDoseHigh_IV, _concentrationIV, 0.5, 0.85]) min 1)
] select (_concentrationIV > _analgesiaDoseLow_IV);

private _effectIM_painSuppression = [
    (linearConversion [_minimumConcentration, _analgesiaDoseLow_IM, _concentrationIM, 0, 0.4, true]),
    ((linearConversion [_analgesiaDoseLow_IM, _analgesiaDoseHigh_IM, _concentrationIM, 0.4, 0.7]) min 0.9)
] select (_concentrationIM > _analgesiaDoseLow_IM);

private _effectIV_HR = [
    (linearConversion [_minimumConcentration, _analgesiaDoseLow_IV, _concentrationIV, 0, 5, true]),
    (linearConversion [_analgesiaDoseLow_IV, _analgesiaDoseHigh_IV, _concentrationIV, 5, 10, true])
] select (_concentrationIV > _analgesiaDoseLow_IV);

private _effectIM_HR = [
    (linearConversion [_minimumConcentration, _analgesiaDoseLow_IM, _concentrationIM, 0, 2, true]),
    (linearConversion [_analgesiaDoseLow_IM, _analgesiaDoseHigh_IM, _concentrationIM, 2, 6, true])
] select (_concentrationIM > _analgesiaDoseLow_IM);

private _effectIV_peripheralResistance = [
    (linearConversion [_minimumConcentration, _analgesiaDoseLow_IV, _concentrationIV, 0, 2, true]),
    (linearConversion [_analgesiaDoseLow_IV, _analgesiaDoseHigh_IV, _concentrationIV, 2, 6])
] select (_concentrationIV > _analgesiaDoseLow_IV);

private _effectIM_peripheralResistance = [
    (linearConversion [_minimumConcentration, _analgesiaDoseLow_IM, _concentrationIM, 0, 1, true]),
    (linearConversion [_analgesiaDoseLow_IM, _analgesiaDoseHigh_IM, _concentrationIM, 1, 2])
] select (_concentrationIM > _analgesiaDoseLow_IM);

private _effectIV_RR = [
    (linearConversion [_sedationDoseHigh_IV, (_sedationDoseHigh_IV * 1.5), _concentrationIV, 0, -2, true]),
    (linearConversion [(_sedationDoseHigh_IV * 1.5), (_sedationDoseHigh_IV * 3), _concentrationIV, -2, -10])
] select (_concentrationIV > (_sedationDoseHigh_IV * 1.5));

private _effectIM_RR = [
    (linearConversion [_sedationDoseHigh_IM, (_sedationDoseHigh_IM * 1.5), _concentrationIM, 0, -1, true]),
    (linearConversion [(_sedationDoseHigh_IM * 1.5), (_sedationDoseHigh_IM * 3), _concentrationIM, -1, -8])
] select (_concentrationIM > (_sedationDoseHigh_IM * 1.5));

private _effectIV_BreathingEffectiveness = (linearConversion [(_sedationDoseHigh_IV * 1.5), (_sedationDoseHigh_IV * 3), 0, -0.5]) min 0;
private _effectIM_BreathingEffectiveness = (linearConversion [(_sedationDoseHigh_IM * 1.5), (_sedationDoseHigh_IM * 3), 0, -0.3]) min 0;

[
    ((_effectIV_painSuppression max _effectIM_painSuppression) max ((_effectIV_painSuppression min 0.6) + (_effectIM_painSuppression min 0.4))) min 1,
    ([(_effectIV_HR + _effectIM_HR),(_effectIV_HR max _effectIM_HR)] select (_concentrationTotal > 20)) min 20,
    ([(_effectIV_peripheralResistance + _effectIM_peripheralResistance),(_effectIV_peripheralResistance max _effectIM_peripheralResistance)] select (_concentrationTotal > 20)) min 25,
    ([(_effectIV_RR + _effectIM_RR),(_effectIV_RR min _effectIM_RR)] select (_concentrationTotal > _sedationDoseHigh_IV)),
    0,
    ([(_effectIV_BreathingEffectiveness + _effectIM_BreathingEffectiveness),(_effectIV_BreathingEffectiveness min _effectIM_BreathingEffectiveness)] select (_concentrationTotal > (_sedationDoseHigh_IV * 1.5)))
];