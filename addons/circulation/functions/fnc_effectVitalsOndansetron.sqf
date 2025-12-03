#include "..\script_component.hpp"
/*
 * Author: Blue
 * Ondansetron medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Resistance>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsOndansetron;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Ondansetron", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
private _concentrationIM = [_patient, "Ondansetron", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration);
private _concentrationTotal = _concentrationIV + _concentrationIM;

private _effectIV_HR = [
    (linearConversion [_minimumConcentration, 8, _concentrationIV, 0, -4, true]),
    (linearConversion [8, 16, _concentrationIV, -4, -10])
] select (_concentrationIV > 8);

private _effectIM_HR = [
    (linearConversion [_minimumConcentration, 8, _concentrationIM, 0, -2, true]),
    (linearConversion [8, 16, _concentrationIM, -2, -6])
] select (_concentrationIM > 8);

[
    0,
    [(_effectIV_HR + _effectIM_HR),(_effectIV_HR min _effectIM_HR)] select (_concentrationTotal > 8),
    0,
    0,
    0,
    0
];