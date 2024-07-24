#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if body part has IO inserted
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Type <NUMBER>
 *
 * Return Value:
 * Has IO <BOOL>
 *
 * Example:
 * [cursorTarget, "leftarm", 0] call ACM_circulation_fnc_hasIO;
 *
 * Public: No
 */

params ["_patient", "_bodyPart", ["_type", 0]];

private _partIndex = ALL_BODY_PARTS find toLowerANSI _bodyPart;

if (_type == 0) then {
    (GET_IO(_patient) select _partIndex) > 0;
} else {
    (GET_IO(_patient) select _partIndex) == _type;
};