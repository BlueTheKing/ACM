#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if body part can be wrapped, body part must not be bleeding
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Type <NUMBER>
 *
 * Return Value:
 * Can wrap <BOOL>
 *
 * Example:
 * [player, cursorTarget, "head", 0] call ACM_damage_fnc_canWrap;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", ["_type", 0]];

if([_patient, _bodyPart] call FUNC(isBodyPartBleeding)) exitWith {false};

private _condition = false;

switch (_type) do {
    case 2: { // Bruise
        private _openWounds = GET_OPEN_WOUNDS(_patient) getOrDefault [_bodyPart, []];

        {
            _x params ["_id", "_amountOf"];

            if (_id in [20,21,22] && {_amountOf > 0}) then {_condition = true;};
        } forEach _openWounds;
    };
    case 1: {
        _condition = (GET_CLOTTED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) isNotEqualTo [];
    };
    default { // Bandages
        _condition = (GET_BANDAGED_WOUNDS(_patient) getOrDefault [_bodyPart, []]) isNotEqualTo [];
    };
};

_condition;