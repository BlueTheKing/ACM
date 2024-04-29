#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle attempt to slap patient awake
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_disability_fnc_slapAwake;
 *
 * Public: No
 */

params ["_medic", "_patient"];

addCamShake [5, 0.3, 5];

[_patient, "activity", "%1 shook the patient", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(slapAwakeLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;