#include "..\script_component.hpp"
/*
 * Author: Blue
 * Try to reopen already treated wound
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Body Part <STRING>
 * 2: Wound type <INT>
 * 3: Damage <INT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "head", 60, 0.2] call ACM_damage_fnc_handleWoundReopening;
 *
 * Public: No
 */

params ["_unit", "_bodyPart", "_woundType", "_woundDamage"];

private _fnc_getWoundIndex = {
    params ["_unit", "_bodyPart", "_woundType", ["_type", 0]];

    private _index = -1;

    private _woundsToCheck = createHashMap;

    switch (_type) do {
        case 1: {_woundsToCheck = GET_CLOTTED_WOUNDS(_unit);};
        case 2: {_woundsToCheck = GET_WRAPPED_WOUNDS(_unit);};
        case 3: {_woundsToCheck = GET_STITCHED_WOUNDS(_unit);};
        default {_woundsToCheck = GET_BANDAGED_WOUNDS(_unit);};
    };

    private _woundsToCheckOnPart = _woundsToCheck getOrDefault [_bodyPart, []];

    if (_woundsToCheckOnPart isNotEqualTo []) then {
        _index = _woundsToCheckOnPart findIf {(_x select 0) isEqualTo _woundType};
    };

    _index;
};

private _fnc_moveWound = {
    params ["_unit", "_bodyPart", "_woundsHashMap", "_type", "_index", "_woundDamage"];

    private _woundsOnPart = _woundsHashMap getOrDefault [_bodyPart, []];

    private _woundToMove = _woundsOnPart select _index;
    _woundToMove params ["_id", "_amountOf", "_bleeding", "_damage"];

    if (_amountOf < 1) exitWith {};

    private _damageToRemove = _damage / _amountOf;

    private _modifiedWound = [_id, (_amountOf - 1), _bleeding, (_damage - _damageToRemove)];
    _woundsOnPart set [_index, _modifiedWound];
    _woundsHashMap set [_bodyPart, _woundsOnPart];

    switch (_type) do {
        case 1: {_unit setVariable [VAR_CLOTTED_WOUNDS, _woundsHashMap, true];};
        case 2: {_unit setVariable [VAR_WRAPPED_WOUNDS, _woundsHashMap, true];};
        case 3: {_unit setVariable [VAR_STITCHED_WOUNDS, _woundsHashMap, true];};
        default {_unit setVariable [VAR_BANDAGED_WOUNDS, _woundsHashMap, true];};
    };

    if (_type < 3) then {
        private _partIndex = ALL_BODY_PARTS find _bodyPart;
        private _bodyPartDamage = _unit getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]];
        private _damage = (_bodyPartDamage select _partIndex) - _damageToRemove;

        if (_damage > 0.05) then {
            _bodyPartDamage set [_partIndex, _damage];
        } else {
            _bodyPartDamage set [_partIndex, 0];
        };

        _unit setVariable [QACEGVAR(medical,bodyPartDamage), _bodyPartDamage, true];
    };
};

private _woundIndex = -1;

_woundIndex = [_unit, _bodyPart, _woundType, 1] call _fnc_getWoundIndex; // clots

if (_woundIndex != -1) exitWith {
    [_unit, _bodyPart, GET_CLOTTED_WOUNDS(_unit), 1, _woundIndex, _woundDamage] call _fnc_moveWound;
};

_woundIndex = [_unit, _bodyPart, _woundType] call _fnc_getWoundIndex; // bandages

if (_woundIndex != -1) exitWith {
    [_unit, _bodyPart, GET_BANDAGED_WOUNDS(_unit), 0, _woundIndex, _woundDamage] call _fnc_moveWound;
};

_woundIndex = [_unit, _bodyPart, _woundType, 2] call _fnc_getWoundIndex; // wrapped

if (_woundIndex != -1) exitWith {
    [_unit, _bodyPart, GET_WRAPPED_WOUNDS(_unit), 2, _woundIndex, _woundDamage] call _fnc_moveWound;
};

_woundIndex = [_unit, _bodyPart, _woundType, 3] call _fnc_getWoundIndex; // stitched

if (_woundIndex != -1) exitWith {
    [_unit, _bodyPart, GET_STITCHED_WOUNDS(_unit), 3, _woundIndex, _woundDamage] call _fnc_moveWound;
};