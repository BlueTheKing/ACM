#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle attempt to shake patient awake
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_disability_fnc_shakeAwake;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if (ACE_player == _medic) then {
    addCamShake [2, 2, 5];
};

[_patient, "activity", LSTRING(ShakePatient_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(shakeAwakeLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;