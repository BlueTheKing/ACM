#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
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

_ctrlSelectionText ctrlSetText ([(format ["%1 - %2", _bodyPartString, LLSTRING(Intraosseous_Short)]), (format ["%1 - %2 (%3)", _bodyPartString, LLSTRING(Intravenous_Short), ([LLSTRING(IV_Upper), LLSTRING(IV_Middle), LLSTRING(IV_Lower)] select GVAR(TransfusionMenu_Selected_AccessSite))])] select GVAR(TransfusionMenu_SelectIV));