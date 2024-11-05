#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
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

private _text = [LLSTRING(Common_Self), LLSTRING(Common_Patient), LLSTRING(Common_Vehicle)] select GVAR(TransfusionMenu_Selected_Inventory);

private _target = [ACE_player, GVAR(TransfusionMenu_Target), _vehicle] select GVAR(TransfusionMenu_Selected_Inventory);

_ctrlInventorySelectText ctrlSetText (format [LLSTRING(Common_InventoryTarget), _text]);

private _cachedItems = [ACE_player, 0] call ACEFUNC(common,uniqueItems);

private _fluidsArray = +GVAR(Fluids_Array);
private _fluidsArrayData = +GVAR(Fluids_Array_Data);

private _index = _fluidsArray findIf {_x in _cachedItems};

if (_index < 0) exitWith {};

private _ctrlInventoryPanel = _display displayCtrl IDC_TRANSFUSIONMENU_RIGHTLISTPANEL;

lbClear _ctrlInventoryPanel;

private _activeFreshBloodList = missionNamespace getVariable [QGVAR(FreshBloodList), createHashMap];

if (count _activeFreshBloodList > 0) then {
    {
        private _id = _forEachIndex;
        (_activeFreshBloodList get _id) params ["", "_volume"];

        _fluidsArray pushBack (format ["%1_%2", (["FreshBlood", _volume] call FUNC(formatFluidBagName)), _id]);
        _fluidsArrayData pushBack (format ["%1_%2", (["FreshBlood", _volume, -1, true] call FUNC(formatFluidBagName)), _id]);
    } forEach _activeFreshBloodList;
};

if (GVAR(TransfusionMenu_Selected_Inventory) == 2) then {
    {
        private _inventory = getItemCargo _vehicle;
        private _classname = _x;
        private _targetIndex = (_inventory select 0) findIf {_x == _classname};
        if (_targetIndex < 0) then {
            continue;
        };
        private _count = (_inventory select 1) select _targetIndex;

        if (_count > 0) then { 
            private _config = (configFile >> "CfgWeapons" >> _x);
            private _name = [(getText (_config >> "displayName")), (getText (_config >> "shortName"))] select (isText (_config >> "shortName"));
            private _i = _ctrlInventoryPanel lbAdd _name;
            _ctrlInventoryPanel lbSetPicture [_i, getText (_config >> "picture")];
            _ctrlInventoryPanel lbSetData [_i, (format ["%1|%2",_x,_fluidsArrayData select _forEachIndex])];
            _ctrlInventoryPanel lbSetTooltip [_i, (format [LLSTRING(Common_Available), _count])];
        };
    } forEach _fluidsArray;
} else {
    {
        private _count = [_target, _x] call ACEFUNC(common,getCountOfItem);

        if (_count > 0) then { 
            private _config = (configFile >> "CfgWeapons" >> _x);
            private _name = [(getText (_config >> "displayName")), (getText (_config >> "shortName"))] select (isText (_config >> "shortName"));
            private _i = _ctrlInventoryPanel lbAdd _name;
            _ctrlInventoryPanel lbSetPicture [_i, getText (_config >> "picture")];
            _ctrlInventoryPanel lbSetData [_i, (format ["%1|%2",_x,_fluidsArrayData select _forEachIndex])];
            _ctrlInventoryPanel lbSetTooltip [_i, (format [LLSTRING(Common_Available), _count])];
        };
    } forEach _fluidsArray;
};