#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
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
 * [] call ACM_circulation_fnc_TransfusionMenu_SwitchTargetInventory;
 *
 * Public: No
 */

private _targetInventory = GVAR(TransfusionMenu_Selected_Inventory);

_targetInventory = _targetInventory + 1;

GVAR(TransfusionMenu_Selected_Inventory) = switch (true) do {
    case (ACE_player == GVAR(TransfusionMenu_Target));
    case (_targetInventory > 1 && (isNull objectParent ACE_player));
    case (_targetInventory > 2): {0};
    default {_targetInventory};
};

private _display = uiNamespace getVariable [QGVAR(TransfusionMenu_DLG), displayNull];

private _ctrlInventorySelectText = _display displayCtrl IDC_TRANSFUSIONMENU_SELECTION_INV_TEXT;

private _text = switch (GVAR(TransfusionMenu_Selected_Inventory)) do {
    case 0: {"Self"};
    case 1: {"Patient"};
    case 2: {"Vehicle"};
};

_ctrlInventorySelectText ctrlSetText (format ["Target: %1", _text]);

private _cachedItems = [ACE_player, 0] call ACEFUNC(common,uniqueItems);

private _index = FLUIDS_ARRAY findIf {_x in _cachedItems};

if (_index < 0) exitWith {};

private _ctrlInventoryPanel = _display displayCtrl IDC_TRANSFUSIONMENU_RIGHTLISTPANEL;

lbClear _ctrlInventoryPanel;

{
    private _count = [ACE_player, _x] call ACEFUNC(common,getCountOfItem);

    if (_count > 0) then { 
        private _config = (configFile >> "CfgWeapons" >> _x);
        private _i = _ctrlInventoryPanel lbAdd getText (_config >> "displayName");
        _ctrlInventoryPanel lbSetPicture [_i, getText (_config >> "picture")];
        _ctrlInventoryPanel lbSetData [_i, (format ["%1|%2",_x,FLUIDS_ARRAY_DATA select _forEachIndex])];
        _ctrlInventoryPanel lbSetTooltip [_i, (format ["%1 available", _count])]
    };
} forEach FLUIDS_ARRAY;