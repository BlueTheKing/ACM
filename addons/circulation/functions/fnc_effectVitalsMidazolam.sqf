#include "..\script_component.hpp"
/*
 * Author: Blue
 * Esmolol medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Vasoconstriction Adjustment>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsEsmolol;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Midazolam", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
private _concentrationIM = ([_patient, "Midazolam", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration));

private _desiredDoseLow = 0.5;
private _desiredDoseHigh = 2;
private _desiredDoseTooHigh = 4;

private _effectIV_HR = [
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, 0, -5]),
    (linearConversion [_desiredDoseHigh, _desiredDoseTooHigh, _concentrationIV, -5, -20])
] select (_concentrationIV > _desiredDoseHigh);

private _effectIV_RR = [
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, 0, -2]),
    (linearConversion [_desiredDoseHigh, _desiredDoseTooHigh, _concentrationIV, -2, -10])
] select (_concentrationIV > _desiredDoseHigh);

private _effectIM_HR = [
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, 0, -2]),
    (linearConversion [_desiredDoseHigh, _desiredDoseTooHigh, _concentrationIM, -2, -10])
] select (_concentrationIM > _desiredDoseHigh);

private _effectIM_RR = [
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIM, 0, -1]),
    (linearConversion [_desiredDoseHigh, _desiredDoseTooHigh, _concentrationIM, -1, -5])
] select (_concentrationIM > _desiredDoseHigh);

private _effectIV_BreathingEffectiveness = (linearConversion [_desiredDoseTooHigh, (_sedationDoseHigh_IV * 2), 0, -0.8]) min 0;
private _effectIM_BreathingEffectiveness = (linearConversion [_desiredDoseTooHigh, (_sedationDoseHigh_IM * 2), 0, -0.5]) min 0;

[
    0,
    ([(_effectIV_HR + _effectIM_HR),(_effectIV_HR min _effectIM_HR)] select (_concentrationTotal > 5)),
    0,
    ([(_effectIV_RR + _effectIM_RR),(_effectIV_RR min _effectIM_RR)] select (_concentrationTotal > 5)),
    0,
    ([(_effectIV_BreathingEffectiveness + _effectIM_BreathingEffectiveness),(_effectIV_BreathingEffectiveness min _effectIM_BreathingEffectiveness)] select (_concentrationTotal > _desiredDoseTooHigh))
];