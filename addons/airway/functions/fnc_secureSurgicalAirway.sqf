#include "..\script_component.hpp"
/*
 * Author: Blue
 * Secure surgical airway of patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_airway_fnc_secureSurgicalAirway;
 *
 * Public: No
 */

params ["_medic", "_patient"];

_patient setVariable [QGVAR(SurgicalAirway_StrapSecure), true, true];
_patient setVariable [QGVAR(SurgicalAirway_TubeUnSecure), false, true];

[LLSTRING(SurgicalAirwayStrap_Complete), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "activity", LLSTRING(SurgicalAirwayStrap_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);