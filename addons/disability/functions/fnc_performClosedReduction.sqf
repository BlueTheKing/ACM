#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform closed reduction on patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_performClosedReduction;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

[_patient, "activity", "%1 performed closed reduction", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(performClosedReductionLocal), [_medic, _patient, _bodyPart], _patient] call CBA_fnc_targetEvent;