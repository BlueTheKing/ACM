#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if body part has IV/IO inserted
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Type <NUMBER>
 * 3: Access Site <NUMBER>
 *
 * Return Value:
 * Has IV <BOOL>
 *
 * Example:
 * [cursorTarget, "leftarm", 0, -1] call ACM_circulation_fnc_hasIV;
 *
 * Public: No
 */

params ["_patient", ["_bodyPart", ""], ["_type", 0], ["_accessSite", -1]];

if (_bodyPart == "") exitWith {
    GET_IV(_patient) isNotEqualTo ACM_IV_PLACEMENT_DEFAULT_0;
};

private _partIndex = ALL_BODY_PARTS find toLowerANSI _bodyPart;

if (_type == 0) then {
    if (_accessSite == -1) then {
        (GET_IV(_patient) select _partIndex) params ["_xUpper", "_xMiddle", "_xLower"];

        (_xUpper + _xMiddle + _xLower) > 0;
    } else {
        ((GET_IV(_patient) select _partIndex) select _accessSite) > 0;
    };
} else {
    if (_accessSite == -1) then {
        _type in (GET_IV(_patient) select _partIndex);
    } else {
        ((GET_IV(_patient) select _partIndex) select _accessSite) == _type;
    };
};