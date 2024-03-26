#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset airway variables to default values
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_airway_fnc_resetVariables;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(AirwayCollapse_State), 0, true];

_patient setVariable [QGVAR(AirwayObstructionVomit_State), 0, true];
_patient setVariable [QGVAR(AirwayObstructionVomit_GracePeriod), -1, true];
_patient setVariable [QGVAR(AirwayObstructionVomit_Count), 2, true];

_patient setVariable [QGVAR(AirwayObstructionBlood_State), 0, true];

_patient setVariable [QGVAR(RecoveryPosition_State), false, true];
_patient setVariable [QGVAR(HeadTilt_State), false, true];

_patient setVariable [QGVAR(AirwayItem), "", true];

[_patient] call FUNC(updateAirwayState);