#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle cancelling AED charge
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_circulation_fnc_AED_CancelCharge;
 *
 * Public: No
 */

params ["_medic", "_patient"];

playSound3D [QPATHTO_R(sound\aed_3beep.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.624s

_patient setVariable [QGVAR(AED_Charged), false, true];
_patient setVariable [QGVAR(AED_InUse), false, true];
_medic setVariable [QGVAR(AED_Medic_InUse), false, true];

_patient setVariable [QGVAR(AED_AnalyzeRhythm_State), false, true];