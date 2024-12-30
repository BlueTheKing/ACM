#include "..\script_component.hpp"
/*
 * Author: mharis001
 * Condition for going into cardiac arrest upon receiving a fatal injury.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ace_medical_statemachine_fnc_conditionSecondChance
 *
 * Public: No
 */

params ["_unit"];

if (EGVAR(damage,enable)) exitWith {
    if (_unit getVariable [QGVAR(InstantDeath), false]) then {
        false;
    } else {
        [true, false] select ([_unit] call EFUNC(damage,handleTrauma));
    };
};

if (isPlayer _unit) then {
    ACEGVAR(medical_statemachine,fatalInjuriesPlayer) != FATAL_INJURIES_ALWAYS
} else {
    ACEGVAR(medical_statemachine,fatalInjuriesAI) != FATAL_INJURIES_ALWAYS
}
