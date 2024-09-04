#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get number of tickets available.
 *
 * Arguments:
 * 0: Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [0] call ACM_evacuation_fnc_getAvailableTickets;
 *
 * Public: No
 */

params ["_type"];

if (_type == 0) exitWith {[GVAR(playerFaction), 0] call BIS_fnc_respawnTickets};

(missionNamespace getVariable [QGVAR(CasualtyTicket_Count), 0]);