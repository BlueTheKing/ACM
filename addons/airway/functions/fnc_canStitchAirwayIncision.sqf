#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return whether patient has surgical airway incision that can be stitched.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * Can Stitch Airway Incision <BOOL>
 *
 * Example:
 * [player, cursorTarget] call ACM_airway_fnc_canStitchAirwayIncision;
 *
 * Public: No
 */

params ["_medic", "_patient"];

_patient getVariable [QGVAR(SurgicalAirway_State), false] && !(_patient getVariable [QGVAR(SurgicalAirway_IncisionStitched), false]) && !(_patient getVariable [QGVAR(SurgicalAirway_InProgress), false]);