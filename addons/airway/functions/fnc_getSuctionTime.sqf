#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get time required to perform medical suction
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Suction Device Type <NUMBER>
 *   0: Manual Suction Bag
 *   1: ACCUVAC
 *
 * Return Value:
 * Suction Time <NUMBER>
 *
 * Example:
 * [cursorTarget, 0] call ACM_airway_fnc_action_getSuctionTime;
 *
 * Public: No
 */

params ["_patient", ["_type", 0]];

private _obstructionState = (_patient getVariable [QGVAR(AirwayObstructionVomit_State), 0]) + (_patient getVariable [QGVAR(AirwayObstructionVomit_State), 0]);

private _return = (4 max (_obstructionState * 2.5)) min 10;

if (_type == 1) exitWith {_return min 8};

_return;