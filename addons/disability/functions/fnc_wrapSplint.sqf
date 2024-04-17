#include "..\script_component.hpp"
/*
 * Author: Blue
 * Wrap splint
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
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_wrapSplint;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

[_patient, "activity", "%1 has wrapped SAM Splint", [[_medic] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(wrapSplintLocal), [_medic, _patient, _bodyPart], _patient] call CBA_fnc_targetEvent;