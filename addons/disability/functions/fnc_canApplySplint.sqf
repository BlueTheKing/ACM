#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if splint can be applied.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * Can apply splint <BOOL>
 *
 * Example:
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_canApplySplint;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

(GET_SPLINTS(_patient) select GET_BODYPART_INDEX(_bodyPart)) == 0;