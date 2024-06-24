#include "..\script_component.hpp"
/*
 * Author: Blue
 * Prepare medication into syringe
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Medication Classname <STRING>
 * 3: IV <BOOL>
 * 4: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 'Epinephrine', false] call ACM_circulation_fnc_Syringe_Prepare;
 *
 * Public: No
 */

params ["_medic", ["_patient", objNull], ["_bodyPart", ""], "_medication", ["_iv", false]];

[_medic, _patient, _bodyPart, _iv, _medication] call FUNC(Syringe_Draw);