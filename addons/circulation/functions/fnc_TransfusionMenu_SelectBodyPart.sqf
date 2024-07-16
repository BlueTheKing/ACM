#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
/*
 * Author: Blue
 * Handle selecting body part in transfusion menu.
 *
 * Arguments:
 * 0: Body Part <STRING>
 * 1: Access Site <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["LeftArm", 0] call ACM_circulation_fnc_TransfusionMenu_SelectBodyPart;
 *
 * Public: No
 */

params ["_bodyPart", "_accessSite"];

GVAR(TransfusionMenu_Selected_BodyPart) = _bodyPart;
GVAR(TransfusionMenu_Selected_AccessSite) = _accessSite;

if (_bodyPart == "body") then {
    GVAR(TransfusionMenu_SelectIV) = false;
};

call FUNC(TransfusionMenu_UpdateSelection);