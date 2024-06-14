#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if player can refill oxygen tank at vehicle.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 *
 * Return Value:
 * Can Refill <BOOL>
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_canRefillOxygenTank;
 *
 * Public: No
 */

params ["_unit", "_vehicle"];

"ACM_OxygenTank_425_Empty" in ([_unit, 0] call ACEFUNC(common,uniqueItems)) && ([_vehicle] call ACEFUNC(medical_treatment,isMedicalVehicle));