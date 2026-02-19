#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle chest injury consequences (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Wound ID <NUMBER>
 * 2: Wound Damage <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 60, 1] call ACM_breathing_fnc_handleChestInjury;
 *
 * Public: No
 */

params ["_patient", "_woundID", "_woundDamage"];

if !(_patient getVariable [QGVAR(ChestInjury_State), false]) then {
    _patient setVariable [QGVAR(ChestInjury_State), true, true];
};

if !(_woundID in GVAR(ChestInjury_Chances)) exitWith {};

(GVAR(ChestInjury_Chances) get _woundID) params ["_minDamage", "_minChance", "_maxDamage", "_maxChance"];

private _chance = linearConversion [_minDamage, _maxDamage, _woundDamage, _minChance, _maxChance, true];

if (random 1 < (_chance * GVAR(chestInjuryChance))) then {
    if (random 1 < GVAR(hemothoraxChance)) then {
        [_patient] call FUNC(handleHemothorax);
    } else {
        [_patient] call FUNC(handlePneumothorax);
    };
    [_patient] call FUNC(updateLungState);
};

if (_patient getVariable [QGVAR(ChestSeal_State), false]) then {
    _patient setVariable [QGVAR(ChestSeal_State), false, true];
};