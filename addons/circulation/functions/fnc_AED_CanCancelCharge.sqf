#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if AED charge can be cancelled
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * Can cancel charge <BOOL>
 *
 * Example:
 * [player, cursorTarget] call ACM_circulation_fnc_AED_CanCancelCharge;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[_patient, "", 1] call FUNC(hasAED) && (_patient getVariable [QGVAR(AED_InUse), false]) && (_patient getVariable [QGVAR(AED_Charged), false]);