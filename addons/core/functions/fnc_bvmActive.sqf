#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return if patient has active BVM
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Is BVM being used on unit
 *
 * Example:
 * [player] call ACM_core_fnc_bvmActive;
 *
 * Public: No
 */

params ["_patient"];

alive (_patient getVariable [QEGVAR(breathing,BVM_provider), objNull])