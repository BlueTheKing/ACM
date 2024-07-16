#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
/*
 * Author: Blue
 * Handle toggle IV button.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_circulation_fnc_TransfusionMenu_ToggleIV;
 *
 * Public: No
 */

if (_bodyPart == "body" && !(GVAR(TransfusionMenu_SelectIV))) exitWith {};

GVAR(TransfusionMenu_SelectIV) = !GVAR(TransfusionMenu_SelectIV);

call FUNC(TransfusionMenu_UpdateSelection);