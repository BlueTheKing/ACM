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

private _vehicle = objectParent ACE_player;

switch (_targetInventory) do {
    case 1: {
        if (ACE_player == GVAR(TransfusionMenu_Target)) then {
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

GVAR(TransfusionMenu_Selected_Inventory) = _targetInventory;

private _display = uiNamespace getVariable [QGVAR(TransfusionMenu_DLG), displayNull];

private _ctrlInventorySelectText = _display displayCtrl IDC_TRANSFUSIONMENU_SELECTION_INV_TEXT;

private _text = [LLSTRING(TransfusionMenu_InventoryTarget_Self), LLSTRING(TransfusionMenu_InventoryTarget_Patient), LLSTRING(TransfusionMenu_InventoryTarget_Vehicle)] select GVAR(TransfusionMenu_Selected_Inventory);

private _target = [ACE_player, GVAR(TransfusionMenu_Target), _vehicle] select GVAR(TransfusionMenu_Selected_Inventory);

_ctrlInventorySelectText ctrlSetText (format [LLSTRING(TransfusionMenu_InventoryTarget), _text]);

private _cachedItems = [ACE_player, 0] call ACEFUNC(common,uniqueItems);

private _index = GVAR(Fluids_Array) findIf {_x in _cachedItems};

if (_index < 0) exitWith {};

private _ctrlInventoryPanel = _display displayCtrl IDC_TRANSFUSIONMENU_RIGHTLISTPANEL;

lbClear _ctrlInventoryPanel;

if (GVAR(TransfusionMenu_Selected_Inventory) == 2) then {
    {
        private _inventory = getItemCargo _vehicle;
        private _classname = _x;
        private _targetIndex = (_inventory select 0) findIf {_x == _classname};
        if (_targetIndex < 0) then {
            break;
        };
        private _count = (_inventory select 1) select _targetIndex;

        if (_count > 0) then { 
            private _config = (configFile >> "CfgWeapons" >> _x);
            private _i = _ctrlInventoryPanel lbAdd getText (_config >> "displayName");
            _ctrlInventoryPanel lbSetPicture [_i, getText (_config >> "picture")];
            _ctrlInventoryPanel lbSetData [_i, (format ["%1|%2",_x,GVAR(Fluids_Array_Data) select _forEachIndex])];
            _ctrlInventoryPanel lbSetTooltip [_i, (format [LLSTRING(TransfusionMenu_InventoryTarget_Available), _count])];
        };
    } forEach GVAR(Fluids_Array);
} else {
    {
        private _count = [_target, _x] call ACEFUNC(common,getCountOfItem);

        if (_count > 0) then { 
            private _config = (configFile >> "CfgWeapons" >> _x);
            private _i = _ctrlInventoryPanel lbAdd getText (_config >> "displayName");
            _ctrlInventoryPanel lbSetPicture [_i, getText (_config >> "picture")];
            _ctrlInventoryPanel lbSetData [_i, (format ["%1|%2",_x,GVAR(Fluids_Array_Data) select _forEachIndex])];
            _ctrlInventoryPanel lbSetTooltip [_i, (format [LLSTRING(TransfusionMenu_InventoryTarget_Available), _count])];
        };
    } forEach GVAR(Fluids_Array);
};