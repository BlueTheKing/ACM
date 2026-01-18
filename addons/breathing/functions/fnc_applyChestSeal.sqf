#include "..\script_component.hpp"
/*
 * Author: Blue
 * Use chest seal on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_applyChestSeal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[_patient, LSTRING(ChestSeal)] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", LLSTRING(ChestSeal_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(applyChestSealLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;