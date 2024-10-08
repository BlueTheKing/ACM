#include "..\script_component.hpp"
#include "..\SyringeDraw_defines.hpp"
/*
 * Author: Blue
 * Handle moving syringe plunger in syringe dialog.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_circulation_fnc_Syringe_Draw_Move;
 *
 * Public: No
 */

if !(GVAR(SyringeDraw_MedicationSelected)) exitWith {};

GVAR(SyringeDraw_Moving) = !GVAR(SyringeDraw_Moving);

private _display = uiNamespace getVariable [QGVAR(SyringeDraw_DLG), displayNull];
private _ctrlPlunger = _display displayCtrl IDC_SYRINGEDRAW_PLUNGER;

_ctrlPlunger ctrlSetTooltip ([LLSTRING(Syringe_MovePlunger), ""] select (GVAR(SyringeDraw_Moving)));