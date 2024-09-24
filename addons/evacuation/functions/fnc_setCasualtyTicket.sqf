#include "..\script_component.hpp"
/*
 * Author: Blue
 * Add or remove casualty ticket.
 *
 * Arguments:
 * 0: Add? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call ACM_evacuation_fnc_setCasualtyTicket;
 *
 * Public: No
 */

params [["_add", true]];

private _tickets = missionNamespace getVariable [QGVAR(CasualtyTicket_Count), 0];
private _newTickets = [(_tickets - 1), (_tickets + 1)] select _add;

missionNamespace setVariable [QGVAR(CasualtyTicket_Count), _newTickets, true];