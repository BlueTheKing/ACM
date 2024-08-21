#include "..\script_component.hpp"
#include "..\SyringeDraw_defines.hpp"
/*
 * Author: Blue
 * Prepare medication into syringe
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_circulation_fnc_Syringe_UpdateMedicationList;
 *
 * Public: No
 */
private _display = uiNamespace getVariable [QGVAR(SyringeDraw_DLG), displayNull];
private _ctrlMedList = _display displayCtrl IDC_SYRINGEDRAW_MEDLIST;

lbClear _ctrlMedList;

if (GVAR(SyringeDraw_InventorySelection) == 2) then {
    {
        private _classname = _x;
        private _vehicleInventory = getItemCargo _vehicle;
        private _targetIndex = (_inventory select 0) findIf {_x == _classname};
        if (_targetIndex < 0) then {
            break;
        };
        private _count = (_inventory select 1) select _targetIndex;

        if (_count > 0) then {
            private _config = (configFile >> "CfgWeapons" >> _classname);

            private _i = _ctrlMedList lbAdd getText (_config >> "displayName");
            _ctrlMedList lbSetPicture [_i, getText (_config >> "picture")];
            _ctrlMedList lbSetData [_i, ((_classname splitString "_") select 2)];
            _ctrlMedList lbSetTooltip [_i, (format [LLSTRING(Common_Available), _count])];
        };
    } forEach ACM_MEDICATION_VIALS;
} else {
    private _inventoryTarget = [ACE_player, GVAR(SyringeDraw_Target)] select GVAR(SyringeDraw_InventorySelection);

    {
        private _classname = _x;
        private _count = [_inventoryTarget,_classname] call ACEFUNC(common,getCountOfItem);

        if (_count > 0) then {
            private _config = (configFile >> "CfgWeapons" >> _classname);

            private _i = _ctrlMedList lbAdd getText (_config >> "displayName");
            _ctrlMedList lbSetPicture [_i, getText (_config >> "picture")];
            _ctrlMedList lbSetData [_i, ((_classname splitString "_") select 2)];
            _ctrlMedList lbSetTooltip [_i, (format [LLSTRING(Common_Available), _count])];
        };
    } forEach ACM_MEDICATION_VIALS;
};