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
    private _headTraumaThreshold = GVAR(headTraumaCardiacArrestThresholdAI);
    private _bodyTraumaThreshold = GVAR(bodyTraumaCardiacArrestThresholdAI);

    ((_headDamage > _headTraumaThreshold && _headTraumaThreshold > 0) || (_bodyDamage > _bodyTraumaThreshold && _bodyTraumaThreshold > 0));
};

private _headTraumaThreshold = GVAR(headTraumaCardiacArrestThreshold);
private _bodyTraumaThreshold = GVAR(bodyTraumaCardiacArrestThreshold);

((_headDamage > _headTraumaThreshold && _headTraumaThreshold > 0) || (_bodyDamage > _bodyTraumaThreshold && _bodyTraumaThreshold > 0));