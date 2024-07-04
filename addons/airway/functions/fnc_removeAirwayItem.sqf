#include "..\script_component.hpp"
/*
 * Author: Blue
 * Remove inserted airway item
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Nasal Airway <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, false] call ACM_airway_fnc_removeAirwayItem;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_nasalAirway", false]];

if (_nasalAirway) then {
    private _airway = _patient getVariable [QGVAR(AirwayItem_Nasal), ""];

    _patient setVariable [QGVAR(AirwayItem_Nasal), "", true];
    [_patient] call FUNC(updateAirwayState);

    if (GVAR(airwayAdjunctReusable)) then {
        if (_airway == "NPA") then {
            [_medic, "ACM_NPA_Used"] call ACEFUNC(common,addToInventory);
        };
    };
} else {
    private _airway = _patient getVariable [QGVAR(AirwayItem_Oral), ""];

    _patient setVariable [QGVAR(AirwayItem_Oral), "", true];
    [_patient] call FUNC(updateAirwayState);

    if (GVAR(airwayAdjunctReusable)) then {
        if (_airway == "OPA") then {
            [_medic, "ACM_GuedelTube_Used"] call ACEFUNC(common,addToInventory);
        } else {
            [_medic, "ACM_IGel_Used"] call ACEFUNC(common,addToInventory);
        };
    };
};