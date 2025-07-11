#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if player can use BVM on patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: In Progress Check? <BOOL>
 *
 * Return Value:
 * Can use BVM? <BOOL>
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_canUseBVM;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_inProgress", false]];

if (!_inProgress && (alive (_patient getVariable [QGVAR(BVM_Medic), objNull]))) exitWith {
    false;
};

!(_patient call ACEFUNC(common,isAwake)) || (_patient call ACEFUNC(common,isAwake) && (_patient getVariable [QEGVAR(core,Lying_State), false]))