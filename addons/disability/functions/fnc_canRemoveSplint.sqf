#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if splint can be removed
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * Can remove splint <BOOL>
 *
 * Example:
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_canRemoveSplint;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

(GET_SPLINTS(_patient) select (ALL_BODY_PARTS find toLower _bodyPart)) > 0;