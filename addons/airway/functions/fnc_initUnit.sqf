#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init unit.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_airway_fnc_initUnit;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(AirwayObstructionVomit_Count), (round(2 + random 2)), true];