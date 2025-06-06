#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle opening vehicle door in hazard zone. (LOCAL)
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Role <STRING>
 * 2: Vehicle <OBJECT>
 * 3: Turret <STRING>
 * 4: Is Eject <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_CBRN_fnc_handleVehicleDoorOpen;
 *
 * Public: No
 */

params ["_unit", "_role", "_vehicle", "_turret", ["_isEject", false]];

if !(_vehicle in (GVAR(Vehicle_List) get "sealed")) exitWith {};