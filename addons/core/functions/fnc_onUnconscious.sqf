#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient unconscious event
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Unconscious State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, true] call AMS_core_fnc_onUnconscious;
 *
 * Public: No
 */

params ["_patient", "_state"];

if (!local _patient) exitWith {};

if !(_state) then {
    _patient setVariable [QGVAR(FatalInjury_Grazed), false];
};