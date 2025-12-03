#include "..\script_component.hpp"
/*
 * Author: Blue
 * Paracetamol medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Resistance>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsParacetamol;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationPO = [_patient, "Paracetamol", [ACM_ROUTE_PO]] call FUNC(getMedicationConcentration);

private _painSuppression = linearConversion [_minimumConcentration, 1000, _concentrationPO, 0, 0.35, true];

[
    _painSuppression,
    0,
    0,
    0,
    0,
    0
];