#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
/*
 * Author: Blue
 * Open transfusion menu.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "LeftArm"] call ACM_circulation_fnc_openTransfusionMenu;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

createDialog QGVAR(TransfusionMenu_Dialog);
uiNamespace setVariable [QGVAR(TransfusionMenu_DLG),(findDisplay IDC_TRANSFUSIONMENU)];