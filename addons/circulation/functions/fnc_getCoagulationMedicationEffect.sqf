#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return coagulation effect of medication.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Medication effect <NUMBER>
 *
 * Example:
 * [cursorTarget] call ACM_circulation_fnc_getCoagulationMedicationEffect;
 *
 * Public: No
 */

params ["_patient"];

private _effect = ([_patient, "TXA", [ACM_ROUTE_IM,ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / 1000;

_effect;