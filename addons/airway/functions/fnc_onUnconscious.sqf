#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient going unconscious
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Unconscious State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, true] call AMS_airway_fnc_onUnconscious;
 *
 * Public: No
 */

params ["_patient", "_state"];

if (!local _patient) exitWith {};

if !(_state) exitWith {
    if !(IS_UNCONSCIOUS(_patient)) then {
        [_patient] call FUNC(onWakeUp);
    }; 
};

[_patient] call FUNC(handleAirway);