#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle suction of airway (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call ACM_airway_fnc_handleSuctionLocal;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(AirwayObstructionVomit_State), 0, true];
_patient setVariable [QGVAR(AirwayObstructionBlood_State), 0, true];
_patient setVariable [QGVAR(AirwayObstructionVomit_GracePeriod), CBA_missionTime, true];
[_patient] call FUNC(updateAirwayState);