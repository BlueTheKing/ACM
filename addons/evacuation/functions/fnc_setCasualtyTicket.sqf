#include "..\script_component.hpp"
/*
 * Author: Blue
 * Add or remove casualty ticket.
 *
 * Arguments:
 * 0: Add? <BOOL>
 * 1: Side <NUMBER>
 *   0: BLUFOR
 *   1: REDFOR
 *   2: GREENFOR
 *
 * Return Value:
 * None
 *
 * Example:
 * [true, 0] call ACM_evacuation_fnc_setCasualtyTicket;
 *
 * Public: No
 */

params [["_add", true], ["_side", 0]];

private _tickets = missionNamespace getVariable [GET_NAMESPACE_TICKETCOUNT(_side), 0];
private _newTickets = [(_tickets - 1), (_tickets + 1)] select _add;

missionNamespace setVariable [GET_NAMESPACE_TICKETCOUNT(_side), _newTickets, true];