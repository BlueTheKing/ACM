#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get time required to apply pads
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * Apply Time <NUMBER>
 *
 * Example:
 * [player] call ACM_circulation_fnc_getApplyPadsTime;
 *
 * Public: No
 */

params ["", "_patient"];

[5, 10] select (alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull]));