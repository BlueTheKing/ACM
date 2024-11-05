#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check for empty wound hashmaps and clear
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 0] call ACM_damage_fnc_refreshWounds;
 *
 * Public: No
 */

params ["_patient", ["_type", 0]];

private _targetWounds = GET_BANDAGED_WOUNDS(_patient);
private _targetWoundsVar = VAR_BANDAGED_WOUNDS;

switch (_type) do {
    case 2: { // Wrapped
        _targetWounds = GET_WRAPPED_WOUNDS(_patient);
        _targetWoundsVar = VAR_WRAPPED_WOUNDS;
    };
    case 1: { // Clotted
        _targetWounds = GET_CLOTTED_WOUNDS(_patient);
        _targetWoundsVar = VAR_CLOTTED_WOUNDS;
    };
    default {}; // Bandaged
};

{
    private _bodyPart = _x;
    private _targetWoundsOnPart = _targetWounds getOrDefault [_bodyPart, []];

    if (_targetWoundsOnPart isEqualTo []) then {
        continue;
    };

    {
        _x params ["_id", "_amount"];

        if (_amount < 1) then {
            _targetWoundsOnPart deleteAt ((count _targetWoundsOnPart) - 1);
        };
    } forEachReversed _targetWoundsOnPart;

    _targetWounds set [_bodyPart, _targetWoundsOnPart];
} forEach ALL_BODY_PARTS;

_patient setVariable [_targetWoundsVar, _targetWounds, true];