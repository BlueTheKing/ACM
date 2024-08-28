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
    private _headTraumaThreshold = GVAR(headTraumaDeathThresholdAI);
    private _bodyTraumaThreshold = GVAR(bodyTraumaDeathThresholdAI);

    ((_headDamage > _headTraumaThreshold && _headTraumaThreshold > 0) || (_bodyDamage > _bodyTraumaThreshold && _bodyTraumaThreshold > 0));
};

private _headTraumaThreshold = GVAR(headTraumaDeathThreshold);
private _bodyTraumaThreshold = GVAR(bodyTraumaDeathThreshold);

((_headDamage > _headTraumaThreshold && _headTraumaThreshold > 0) || (_bodyDamage > _bodyTraumaThreshold && _bodyTraumaThreshold > 0));