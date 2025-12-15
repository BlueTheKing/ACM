#include "..\script_component.hpp"
/*
 * Author: Blue
 * Amiodarone medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Vasoconstriction Adjustment>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsAmiodarone;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Amiodarone", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);

private _HRAdjust = [
    (linearConversion [_minimumConcentration, 300, _concentrationIV, 0, -10, true]),
    (linearConversion [300, 900, _concentrationIV, -10, -35])
] select (_concentrationIV > 300);

[
    0,
    _HRAdjust,
    0,
    0,
    0,
    0
];