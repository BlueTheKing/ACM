#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return if unit has taken damage amount worthy of cardiac arrest
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part Damage <ARRAY<NUMBER>>
 *
 * Return Value:
 * Should Die <BOOL>
 *
 * Example:
 * [cursorObject, [0,0,0,0,0,0]] call ACM_damage_fnc_handleCardiacArrestTrauma;
 *
 * Public: No
 */

params ["_patient", "_bodyPartDamage"];

_bodyPartDamage params ["_headDamage", "_bodyDamage"];

if !(isPlayer _patient) exitWith {
    [false, true] select ((_headDamage > (GVAR(headTraumaDeathThreshold) * GVAR(headTraumaCardiacArrestThreshold) * GVAR(traumaModifierAI)) ) || (_bodyDamage > (GVAR(bodyTraumaDeathThreshold) * GVAR(traumaModifierAI) * GVAR(bodyTraumaCardiacArrestThreshold))));
};

if (_headDamage > (GVAR(headTraumaDeathThreshold) * GVAR(headTraumaCardiacArrestThreshold)) || _bodyDamage > (GVAR(bodyTraumaDeathThreshold) * GVAR(bodyTraumaCardiacArrestThreshold))) exitWith {true};

false;