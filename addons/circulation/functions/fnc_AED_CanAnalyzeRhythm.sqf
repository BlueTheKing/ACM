#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if AED can analyze rhythm
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * Can analyze rhythm <BOOL>
 *
 * Example:
 * [player, cursorTarget] call ACM_circulation_fnc_AED_CanAnalyzeRhythm;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[_patient, "", 1] call FUNC(hasAED) && !(_patient getVariable [QGVAR(AED_InUse), false]);