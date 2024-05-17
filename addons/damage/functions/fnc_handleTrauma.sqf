#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return if unit has taken damage amount worthy of an instant death.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part Damage <ARRAY<NUMBER>>
 *
 * Return Value:
 * Should Die <BOOL>
 *
 * Example:
 * [cursorObject, [0,0,0,0,0,0]] call ACM_damage_fnc_handleTrauma;
 *
 * Public: No
 */

params ["_patient", ["_bodyPartDamage", []]];

if (_bodyPartDamage isEqualTo []) then {
    _bodyPartDamage = _patient getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]];
};

_bodyPartDamage params ["_headDamage", "_bodyDamage"];

if !(isPlayer _patient) exitWith {
    [false, true] select ((_headDamage > (GVAR(headTraumaDeathThreshold) * GVAR(traumaModifierAI)) ) || (_bodyDamage > (GVAR(bodyTraumaDeathThreshold) * GVAR(traumaModifierAI))));
};

if (_headDamage > GVAR(headTraumaDeathThreshold) || _bodyDamage > GVAR(bodyTraumaDeathThreshold)) exitWith {true};

false;