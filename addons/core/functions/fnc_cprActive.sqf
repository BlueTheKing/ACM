#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return if patient has CPR performed on them
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Is CPR being performed on unit
 *
 * Example:
 * [player] call ACM_core_fnc_cprActive;
 *
 * Public: No
 */

params ["_patient"];

alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull])