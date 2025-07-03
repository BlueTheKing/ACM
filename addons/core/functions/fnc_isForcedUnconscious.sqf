#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if patient is forced unconscious.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Is Forced Unconscious? <BOOL>
 *
 * Example:
 * [player] call ACM_core_fnc_isForcedUnconscious;
 *
 * Public: No
 */

params ["_patient"];

(_patient getVariable [QEGVAR(evacuation,casualtyTicketClaimed), false]) || (_patient getVariable [QEGVAR(airway,SurgicalAirway_State), false]);