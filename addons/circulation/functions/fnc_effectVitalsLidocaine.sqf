#include "..\script_component.hpp"
/*
 * Author: Blue
 * Lidocaine medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Resistance>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsLidocaine;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Lidocaine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);
//private _concentrationIM = [_patient, "Lidocaine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration);
//private _concentrationTotal = _concentrationIV + _concentrationIM;

private _weight = GET_BODYWEIGHT(_patient);

private _desiredDoseLow = _weight;
private _desiredDoseHigh = 3 * _weight;

private _effectIV_HR = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -2, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -2, -10])
] select (_concentrationIV > _desiredDoseLow);

private _effectIV_peripheralResistance = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -4, true]),
    (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -4, -8])
] select (_concentrationIV > _desiredDoseLow);

[
    0,
    _effectIV_HR,
    _effectIV_peripheralResistance,
    0,
    0,
    0
];