#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient waking up
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_airway_fnc_onWakeUp;
 *
 * Public: No
 */

params ["_patient"];

[_patient] call FUNC(resetVariables);