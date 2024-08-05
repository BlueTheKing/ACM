#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if patient was shocked by AED recently
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Is Monitor <BOOL>
 *
 * Return Value:
 * Was shocked recently <BOOL>
 *
 * Example:
 * [player] call ACM_circulation_fnc_recentAEDShock;
 *
 * Public: No
 */

params ["_patient", ["_monitor", false]];

if !(_monitor) exitWith {(_patient getVariable [QEGVAR(circulation,AED_LastShock), -60]) + 60 > CBA_missionTime};

(_patient getVariable [QEGVAR(circulation,AED_LastShock), -65]) + 65 > CBA_missionTime;