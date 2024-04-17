#include "..\script_component.hpp"
/*
 * Author: Blue
 * Wrap bruises on body part (treatment)
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
 * [player, cursorTarget, "head"] call ACM_damage_fnc_wrapBruises;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

[QGVAR(wrapBruisesLocal), [_medic, _patient, _bodyPart], _patient] call CBA_fnc_targetEvent;

[_patient, "activity", "%1 has wrapped %2", [[_medic] call ACEFUNC(common,getName), "bruises"]] call ACEFUNC(medical_treatment,addToLog);