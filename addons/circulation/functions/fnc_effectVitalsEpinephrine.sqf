#include "..\script_component.hpp"
/*
 * Author: Blue
 * Epinephrine medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Vasoconstriction Adjustment>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsEpinephrine;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Epinephrine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
private _concentrationIM = [_patient, "Epinephrine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration);
private _concentrationTotal = _concentrationIV + _concentrationIM;

private _effectIV_HR = [
    (linearConversion [_minimumConcentration, 1, _concentrationIV, 1, 50, true]),
    (linearConversion [1, 2, _concentrationIV, 50, 120])
] select (_concentrationIV > 1.1);

private _effectIM_HR = [
    (linearConversion [_minimumConcentration, 0.9, _concentrationIM, 1, 25, true]),
    (linearConversion [0.9, 2, _concentrationIM, 25, 60])
] select (_concentrationIM > 0.9);

private _effectIV_RR = [
    (linearConversion [_minimumConcentration, 1, _concentrationIV, 2, 10, true]),
    (linearConversion [1, 2, _concentrationIV, 10, 24])
] select (_concentrationIV > 1.1);

private _effectIM_RR = [
    (linearConversion [_minimumConcentration, 0.9, _concentrationIM, 1, 6, true]),
    (linearConversion [0.9, 2, _concentrationIM, 6, 12])
] select (_concentrationIM > 0.9);

private _effectIV_BreathingEffectiveness = linearConversion [_minimumConcentration, 1, _concentrationIV, 0.01, 0.04, true];
private _effectIM_BreathingEffectiveness = linearConversion [_minimumConcentration, 0.9, _concentrationIM, 0, 0.01, true];

private _effectiveness = 1;

private _timeSinceROSC = (CBA_missionTime - (_patient getVariable [QGVAR(ROSC_Time), -240]));

if (_timeSinceROSC < 240) then {
    _effectiveness = linearConversion [0, 240, _timeSinceROSC, 0.2, 1, true];
};

[
    0,
    (([(_effectIV_HR + _effectIM_HR),(_effectIV_HR max _effectIM_HR)] select (_concentrationTotal > 2)) * _effectiveness),
    0,
    (([(_effectIV_RR + _effectIM_RR),(_effectIV_RR max _effectIM_RR)] select (_concentrationTotal > 2)) * _effectiveness),
    0,
    (([(_effectIV_BreathingEffectiveness + _effectIM_BreathingEffectiveness),(_effectIV_BreathingEffectiveness max _effectIM_BreathingEffectiveness)] select (_concentrationTotal > 2)) * _effectiveness)
];