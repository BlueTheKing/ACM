#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get time required to wrap bandages based on amount of bandaged wounds
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Type <NUMBER>
 *
 * Return Value:
 * Treatment Time <NUMBER>
 *
 * Example:
 * [player, cursorObject, "head", 0] call ACM_damage_fnc_getWrapTime;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type"];

private _woundsOnPart = [];
private _total = 0;

if (_type isEqualTo 1) then {
    _woundsOnPart = GET_CLOTTED_WOUNDS(_patient) getOrDefault [_bodyPart, [], true];
} else {
    _woundsOnPart = GET_BANDAGED_WOUNDS(_patient) getOrDefault [_bodyPart, [], true];
};

if (_woundsOnPart isEqualTo []) exitWith {0};

_total = 12 min (count _woundsOnPart * 5);

if (_medic isEqualTo _patient) then {
    _total = _total + BANDAGE_TIME_MOD_SELF;
};

if ([_medic] call ACEFUNC(medical_treatment,isMedic)) then {
    _total = _total + BANDAGE_TIME_MOD_MEDIC;
};

1 max _total;