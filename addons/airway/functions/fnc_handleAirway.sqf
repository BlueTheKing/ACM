#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle airway deterioration while unconscious.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_airway_fnc_handleAirway;
 *
 * Public: No
 */

params ["_patient"];

if !(IS_UNCONSCIOUS(_patient)) exitWith {};

[{
    params ["_patient"];

    [QGVAR(handleAirwayCollapse), [_patient], _patient] call CBA_fnc_targetEvent;
}, [_patient], 10] call CBA_fnc_waitAndExecute;

[{
    params ["_patient"];

    [QGVAR(handleAirwayObstruction_Vomit), [_patient], _patient] call CBA_fnc_targetEvent;
}, [_patient], 10] call CBA_fnc_waitAndExecute;

if (false) then { // TODO check if bleeding from head
    [QGVAR(handleAirwayObstruction_Blood), [_patient], _patient] call CBA_fnc_targetEvent;
};