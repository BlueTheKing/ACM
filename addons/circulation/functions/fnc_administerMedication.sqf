#include "..\script_component.hpp"
/*
 * Author: Blue
 * Administer medication.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Bodypart Index <NUMBER>
 * 3: Mediation Classname <STRING>
 * 4: Dose <NUMBER>
 * 5: Route <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, 0, "Paracetamol", 500, ACM_ROUTE_PO] call ACM_circulation_fnc_administerMedication;
 *
 * Public: No
 */

params ["_medic", "_patient", "_partIndex", "_medication", "_dose", "_route"];

[QGVAR(administerMedicationLocal), [_patient, _partIndex, _medication, _dose, _route], _patient] call CBA_fnc_targetEvent;