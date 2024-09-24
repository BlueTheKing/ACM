#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient being knocked out, prevent instant wakeup. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_handleKnockOut;
 *
 * Public: No
 */

params ["_patient"];

if !(alive _patient) exitWith {};

_patient setVariable [QGVAR(KnockOut_State), true];

if (isPlayer _patient || {(!(isPlayer _patient) && {random 1 > EGVAR(damage,AIStayDownChance)})}) then {
    [{
        params ["_patient"];

        if (!(alive _patient) || !(IS_UNCONSCIOUS(_patient))) exitWith {};

        _patient setVariable [QGVAR(KnockOut_State), false];

        if !(_patient getVariable [QEGVAR(airway,AirwayReflex_State), false]) then { // Able to wake up
            _patient setVariable [QEGVAR(airway,AirwayReflex_State), true, true];
        };
    }, [_patient], (15 + (random 20))] call CBA_fnc_waitAndExecute;
};