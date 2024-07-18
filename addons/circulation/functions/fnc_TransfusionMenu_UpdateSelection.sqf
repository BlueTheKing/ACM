#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
/*
 * Author: Blue
 * Update selection after changing body part or IV/IO selection.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_circulation_fnc_TransfusionMenu_UpdateSelection;
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(TransfusionMenu_DLG), displayNull];

private _ctrlSelectionText = _display displayCtrl IDC_TRANSFUSIONMENU_SELECTIONTEXT;

private _bodyPartString = [GVAR(TransfusionMenu_Selected_BodyPart)] call EFUNC(core,getBodyPartString);

_ctrlSelectionText ctrlSetText ([(format ["%1 - IO", _bodyPartString]), (format ["%1 - IV (%2)", _bodyPartString, (["Upper","Middle","Lower"] select GVAR(TransfusionMenu_Selected_AccessSite))])] select GVAR(TransfusionMenu_SelectIV));