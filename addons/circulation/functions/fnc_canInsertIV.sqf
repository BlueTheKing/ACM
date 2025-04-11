#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if IV can be inserted on body part and access site
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Type <NUMBER>
 * 3: Access Site <NUMBER>
 *
 * Return Value:
 * Can Insert IV <BOOL>
 *
 * Example:
 * [cursorTarget, "leftarm", 0, -1] call ACM_circulation_fnc_canInsertIV;
 *
 * Public: No
 */

params ["_patient", ["_bodyPart", ""], ["_type", 0], ["_accessSite", -1]];

if ([_patient, _bodyPart, _type, _accessSite] call FUNC(hasIV)) exitWith {
    false;
};

if (_accessSite == 0 && _bodyPart in ["leftarm","rightarm"] && {([_patient, _bodyPart] call FUNC(hasPressureCuff) || [_patient, _bodyPart, 3] call FUNC(hasAED))}) exitWith {
    false;
};

true;