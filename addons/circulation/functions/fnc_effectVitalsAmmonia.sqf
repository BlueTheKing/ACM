#include "..\script_component.hpp"
/*
 * Author: Blue
 * Ammonia medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Vasoconstriction Adjustment>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsAmmonia;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationInhale = [_patient, "Ammonia", [ACM_ROUTE_INHALE]] call FUNC(getMedicationConcentration);

private _HRAdjust = [
    (linearConversion [_minimumConcentration, 45, _concentrationInhale, 1, 25, true]),
    (linearConversion [45, 90, _concentrationInhale, 25, 40, true])
] select (_concentrationInhale > 45);

private _RRAdjust = [
    (linearConversion [_minimumConcentration, 45, _concentrationInhale, 3, 4, true]),
    (linearConversion [45, 90, _concentrationInhale, 4, 6, true])
] select (_concentrationInhale > 45);

[
    0,
    _HRAdjust,
    0,
    _RRAdjust,
    0,
    0
];