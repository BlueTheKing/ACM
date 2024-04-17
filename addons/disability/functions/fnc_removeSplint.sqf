#include "..\script_component.hpp"
/*
 * Author: Blue
 * Remove splint from limb (treatment)
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
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_removeSplint;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

[QGVAR(removeSplintLocal), [_medic, _patient, _bodyPart], _patient] call CBA_fnc_targetEvent;

[_patient, "activity", "%1 removed splint", [[_medic] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);