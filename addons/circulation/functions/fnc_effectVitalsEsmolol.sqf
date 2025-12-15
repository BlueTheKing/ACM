#include "..\script_component.hpp"
/*
 * Author: Blue
 * Esmolol medication vitals effects.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Concentration <NUMBER>
 *
 * Return Value:
 * [<Pain Suppress>,<HR Adjust>,<Peripheral Vasoconstriction Adjustment>,<RR Adjust>,<CO2 Sensitivity>,<Breathing Effectiveness>] <ARRAY<NUMBER>>
 *
 * Example:
 * [player, 0.5] call ACM_circulation_fnc_effectVitalsEsmolol;
 *
 * Public: No
 */

params ["_patient", ["_minimumConcentration", 0]];

private _concentrationIV = [_patient, "Esmolol", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration);

private _weight = GET_BODYWEIGHT(_patient);

private _desiredDoseLow = 0.25 * _weight;
private _desiredDoseHigh = 0.5 * _weight;

private _HRAdjust = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -10, true]),
    ([
        (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -10, -20]),
        (linearConversion [_desiredDoseHigh, _desiredDoseHigh * 3, _concentrationIV, -20, -80])
    ] select (_concentrationIV > _desiredDoseHigh))
] select (_concentrationIV > _desiredDoseLow);

private _peripheralVasoconstrictionAdjust = [
    (linearConversion [_minimumConcentration, _desiredDoseLow, _concentrationIV, 0, -5, true]),
    ([
        (linearConversion [_desiredDoseLow, _desiredDoseHigh, _concentrationIV, -5, -10]),
        (linearConversion [_desiredDoseHigh, _desiredDoseHigh * 3, _concentrationIV, -10, -30])
    ] select (_concentrationIV > _desiredDoseHigh))
] select (_concentrationIV > _desiredDoseLow);

[
    0,
    _HRAdjust,
    _peripheralVasoconstrictionAdjust,
    0,
    0,
    0
];