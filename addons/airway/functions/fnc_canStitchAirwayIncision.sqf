#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return whether patient has surgical airway incision that can be stitched.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Suture? <BOOL>
 *
 * Return Value:
 * Can Stitch Airway Incision <BOOL>
 *
 * Example:
 * [player, cursorTarget, false] call ACM_airway_fnc_canStitchAirwayIncision;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_suture", false]];

if (_suture && !([_medic, _patient, ["ACE_suture"]] call ACEFUNC(medical_treatment,hasItem))) exitWith {false};

_patient getVariable [QGVAR(SurgicalAirway_State), false] && !(_patient getVariable [QGVAR(SurgicalAirway_IncisionStitched), false]) && !(_patient getVariable [QGVAR(SurgicalAirway_InProgress), false]);