#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if body part has IV/IO inserted
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Type <NUMBER>
 *
 * Return Value:
 * Has IV <BOOL>
 *
 * Example:
 * [cursorTarget, "leftarm"] call ACM_circulation_fnc_hasIV;
 *
 * Public: No
 */

params ["_patient", "_bodyPart", ["_type", 0]];

private _partIndex = ALL_BODY_PARTS find _bodyPart;

if (_type == 0) then {
    (GET_IV(_patient) select _partIndex) > 0;
} else {
    (GET_IV(_patient) select _partIndex) == _type;
};