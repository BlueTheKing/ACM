#include "..\script_component.hpp"
#include "..\SyringeDraw_defines.hpp"
/*
 * Author: Blue
 * Handle switching inventory target.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_circulation_fnc_Syringe_SwitchTargetInventory;
 *
 * Public: No
 */

if (isNull GVAR(SyringeDraw_Target)) exitWith {};

private _targetInventory = GVAR(SyringeDraw_InventorySelection);

_targetInventory = _targetInventory + 1;

private _vehicle = objectParent ACE_player;

switch (_targetInventory) do {
    case 1: {
        if (ACE_player == GVAR(SyringeDraw_Target)) then {
            if !(isNull _vehicle) then {
                _targetInventory = 2;
            } else {
                _targetInventory = 0;
            };
        };
    };
    case 2: {
        if (isNull _vehicle) then {
            _targetInventory = 0;
        };
    };
    default {
        if (_targetInventory > 2) then {
            _targetInventory = 0;
        };
    };
};

GVAR(SyringeDraw_InventorySelection) = _targetInventory;

private _display = uiNamespace getVariable [QGVAR(SyringeDraw_DLG), displayNull];
private _ctrlInventorySelectText = _display displayCtrl IDC_SYRINGEDRAW_MEDLIST_SELECTION_TEXT;

private _text = [LLSTRING(Common_Self), LLSTRING(Common_Patient), LLSTRING(Common_Vehicle)] select GVAR(SyringeDraw_InventorySelection);
private _target = [ACE_player, GVAR(SyringeDraw_Target), _vehicle] select GVAR(SyringeDraw_InventorySelection);

_ctrlInventorySelectText ctrlSetText (format [LLSTRING(Common_InventoryTarget), _text]);

[] call FUNC(Syringe_UpdateMedicationList);