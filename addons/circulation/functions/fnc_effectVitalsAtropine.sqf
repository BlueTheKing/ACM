#include "..\script_component.hpp"
/*
 * Author: Blue
 * Atropine medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Vasoconstriction Adjustment>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsAtropine;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Atropine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
private _concentrationIM = [_patient, "Atropine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration);
private _concentrationTotal = _concentrationIV + _concentrationIM;

private _effectIV_HR = [
    (linearConversion [_minimumConcentration, 0.5, _concentrationIV, 0, -10, true]),
    ([
        (linearConversion [0.5, 1, _concentrationIV, -10, 30, true]),
        (linearConversion [1, 2, _concentrationIV, 30, 50])
    ] select (_concentrationIV > 1))
] select (_concentrationIV > 0.5);

private _effectIM_HR = [
    (linearConversion [_minimumConcentration, 0.3, _concentrationIM, 0, -5, true]),
    ([
        (linearConversion [0.5, 1, _concentrationIM, -5, 10, true]),
        (linearConversion [1, 2, _concentrationIM, 10, 20])
    ] select (_concentrationIM > 1))
] select (_concentrationIM > 0.3);

private _effectIV_RR = [
    (linearConversion [0.5, 3, _concentrationIV, 0, 10, true]),
    (linearConversion [3, 6, _concentrationIV, 0, 20])
] select (_concentrationIM > 0.3);

private _effectIM_RR = [
    (linearConversion [0.3, 3, _concentrationIM, 0, 8, true]),
    (linearConversion [3, 6, _concentrationIV, 8, 14, true])
] select (_concentrationIM > 0.3);

private _effectIV_BreathingEffectiveness = linearConversion [0.5, 3, _concentrationIV, 0.01, 0.04, true];
private _effectIM_BreathingEffectiveness = linearConversion [0.3, 3, _concentrationIM, 0, 0.01, true];

[
    0,
    [(_effectIV_HR + _effectIM_HR),(_effectIV_HR max _effectIM_HR)] select (_concentrationTotal > 4),
    0,
    [(_effectIV_RR + _effectIM_RR),(_effectIV_RR max _effectIM_RR)] select (_concentrationTotal > 4),
    0,
    [(_effectIV_BreathingEffectiveness + _effectIM_BreathingEffectiveness),(_effectIV_BreathingEffectiveness max _effectIM_BreathingEffectiveness)] select (_concentrationTotal > 4)
];