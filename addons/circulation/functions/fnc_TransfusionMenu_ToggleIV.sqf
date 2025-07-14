#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
/*
 * Author: Blue
 * Handle pressing toggle IV button.
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

if (GVAR(TransfusionMenu_Selected_BodyPart) == "body" && !(GVAR(TransfusionMenu_SelectIV))) exitWith {};
if ((GVAR(TransfusionMenu_SelectIV) && !([GVAR(TransfusionMenu_Target), GVAR(TransfusionMenu_Selected_BodyPart), 0] call FUNC(hasIO))) ||(!(GVAR(TransfusionMenu_SelectIV)) && !([GVAR(TransfusionMenu_Target), GVAR(TransfusionMenu_Selected_BodyPart), 0] call FUNC(hasIV)))) exitWith {};

GVAR(TransfusionMenu_SelectIV) = !GVAR(TransfusionMenu_SelectIV);

call FUNC(TransfusionMenu_UpdateSelection);
[false] call FUNC(TransfusionMenu_UpdateBagList);