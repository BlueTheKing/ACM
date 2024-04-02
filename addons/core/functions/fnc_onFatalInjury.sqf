#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient unconsciousness due to fatal injury event
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_core_fnc_onFatalInjury;
 *
 * Public: No
 */

params ["_patient"];

if (random 100 < GVAR(grazingInjuryChance)) then {
	_patient setVariable [QGVAR(FatalInjury_State), true];
};