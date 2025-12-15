#include "..\script_component.hpp"
/*
 * Author: Blue
 * Adenosine medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Vasoconstriction Adjustment>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsAdenosine;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Adenosine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);

private _HRAdjust = linearConversion [_minimumConcentration, 6, _concentrationIV, 0, -300, true];

[
    0,
    _HRAdjust,
    0,
    0,
    0,
    0
];