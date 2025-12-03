#include "..\script_component.hpp"
/*
 * Author: Blue
 * Methoxyflurane medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Resistance>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsMethoxyflurane;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationInhale = [_patient, "Methoxyflurane", [ACM_ROUTE_INHALE]] call FUNC(getMedicationConcentration);

private _painSuppression = linearConversion [_minimumConcentration, 2, _concentrationInhale, 0, 0.6, true];

private _RRAdjust = [
    (linearConversion [_minimumConcentration, 2, _concentrationInhale, 0, -2, true]),
    (linearConversion [3, 6, _concentrationInhale, -2, -8])
] select (_concentrationInhale > 3);

private _breathingEffectiveness = [0, (linearConversion [3, 5, _concentrationInhale, -0.001, -0.01])] select (_concentrationInhale > 2);

[
    _painSuppression,
    0,
    0,
    _RRAdjust,
    0,
    _breathingEffectiveness
];