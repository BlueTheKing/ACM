#include "..\script_component.hpp"
/*
 * Author: Blue
 * TXA medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Resistance>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsTXA;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "TXA", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);

private _peripheralResistance = [
    (linearConversion [_minimumConcentration, 6000, _concentrationIV, 0, 8, true]),
    (linearConversion [6000, 10000, _concentrationIV, 8, 20])
] select (_concentrationIV > 6000);

[
    0,
    0,
    _peripheralResistance,
    0,
    0,
    0
];