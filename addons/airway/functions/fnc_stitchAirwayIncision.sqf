#include "..\script_component.hpp"
/*
 * Author: Blue
 * Stitch surgical airway incision.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_airway_fnc_stitchAirwayIncision;
 *
 * Public: No
 */

params ["_medic", "_patient"];

_patient setVariable [QGVAR(SurgicalAirway_IncisionStitched), true, true];
[LLSTRING(SurgicalAirwayStitch_Complete), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "activity", LLSTRING(SurgicalAirwayStitch_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);