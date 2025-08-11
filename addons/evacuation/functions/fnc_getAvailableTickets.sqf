#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get number of tickets available.
 *
 * Arguments:
 * 0: Type <NUMBER>
 *   0: Respawn Tickets
 *   1: Casualty Tickets
 * 1: Side <NUMBER>
 *   0: BLUFOR
 *   1: REDFOR
 *   2: GREENFOR
 *
 * Return Value:
 * None
 *
 * Example:
 * [0, 0] call ACM_evacuation_fnc_getAvailableTickets;
 *
 * Public: No
 */

params ["_type", ["_side", 0]];

if (_type == 0) exitWith {[GET_SIDE(_side), 0] call BIS_fnc_respawnTickets};

(missionNamespace getVariable [GET_NAMESPACE_TICKETCOUNT(_side), 0]);