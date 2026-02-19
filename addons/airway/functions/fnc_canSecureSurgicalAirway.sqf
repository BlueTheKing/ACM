#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if surgical airway neck strap can be secured on patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_airway_fnc_canSecureSurgicalAirway;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if (_patient getVariable [QGVAR(SurgicalAirway_StrapSecure), false] || !(HAS_SURGICAL_AIRWAY(_patient))) exitWith {
    false;
};

!(alive (_patient getVariable [QEGVAR(breathing,BVM_Medic), objNull])) && !(_patient getVariable [QGVAR(SurgicalAirway_InProgress), false]);