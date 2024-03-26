#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle chest injury consequences (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Wound ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 60] call AMS_breathing_fnc_handleChestInjury;
 *
 * Public: No
 */

params ["_patient", "_woundID"];

if !(_patient setVariable [QGVAR(ChestInjury_State), false]) then {
    _patient setVariable [QGVAR(ChestInjury_State), true, true];
};

private _chance = GVAR(ChestInjury_Chances) get _woundID;

if (random 100 < _chance) then { // TODO settable chance
    [_patient] call FUNC(handlePneumothorax);
};