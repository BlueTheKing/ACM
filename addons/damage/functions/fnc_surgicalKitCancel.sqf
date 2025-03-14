#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle cancelling stitching action when using sutures.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Used suture? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, true] call ACM_damage_fnc_surgicalKitCancel;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_usedSuture", false]];

if (ACEGVAR(medical_treatment,consumeSurgicalKit) != 2 && !_usedSuture) exitWith {};

[_medic, "ACE_suture"] call ACEFUNC(common,addToInventory);
