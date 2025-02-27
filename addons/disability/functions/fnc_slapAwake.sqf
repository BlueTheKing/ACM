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

addCamShake [2, 0.2, 10];

private _soundVariant = round (1 + (random 2));
playSound3D [format ["%1%2.wav", (QPATHTO_R(sound\slap)), _soundVariant], _patient, false, getPosASL _patient, 10, 1, 10];

[_patient, "activity", LSTRING(SlapPatient_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(slapAwakeLocal), [_medic, _patient], _patient] call CBA_fnc_targetEvent;