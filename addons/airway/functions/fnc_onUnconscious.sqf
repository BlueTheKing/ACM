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
 * [player, true] call ACM_airway_fnc_onUnconscious;
 *
 * Public: No
 */

params ["_patient", "_state"];

if (!local _patient) exitWith {};

if !(_state) exitWith {
    if !(IS_UNCONSCIOUS(_patient)) then { // On wakeup
        [_patient] call FUNC(resetVariables);
    }; 
};

[_patient] call FUNC(handleAirway);