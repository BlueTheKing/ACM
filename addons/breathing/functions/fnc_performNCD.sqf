#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform needle chest decompression on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_performNCD;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[_patient, LSTRING(NCD_NeedleDecompression)] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", LSTRING(NCD_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(performNCDLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;