#include "..\script_component.hpp"
/*
 * Author: Blue
 * Remove inserted airway item
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call AMS_airway_fnc_removeAirwayItem;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _airway = _patient getVariable [QGVAR(AirwayItem), ""];

_patient setVariable [QGVAR(AirwayItem), "", true];
[_patient] call FUNC(updateAirwayState);

if (false) then { // TODO reusable
    if (_airway == "OPA") then {
        [_medic, "AMS_GuedelTube_Used"] call ACEFUNC(common,addToInventory);
    } else {
        [_medic, "AMS_IGel_Used"] call ACEFUNC(common,addToInventory);
    };
};