#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle chest injury consequences
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_breathing_fnc_handleChestInjury;
 *
 * Public: No
 */

params ["_patient"];

if (random 100 < 30) then { // TODO settable chance
    [QGVAR(handlePneumothorax), [_patient], _patient] call CBA_fnc_targetEvent;
};