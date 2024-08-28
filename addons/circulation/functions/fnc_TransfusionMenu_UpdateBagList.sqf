#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
/*
 * Author: Blue
 * Handle updating tranfusion bag list.
 *
 * Arguments:
 * 0: Is Update? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [false] call ACM_circulation_fnc_TransfusionMenu_UpdateBagList;
 *
 * Public: No
 */

params [["_update", false]];

private _display = uiNamespace getVariable [QGVAR(TransfusionMenu_DLG), displayNull];

private _ctrlBagPanel = _display displayCtrl IDC_TRANSFUSIONMENU_LEFTLISTPANEL;

private _IVBagsOnBodyPart = (GVAR(TransfusionMenu_Target) getVariable [QGVAR(IV_Bags), createHashMap]) getOrDefault [GVAR(TransfusionMenu_Selected_BodyPart), []];

if !(_update) then {
    lbClear _ctrlBagPanel;
    GVAR(TransfusionMenu_Selection_IVBags) = [];

    if (count _IVBagsOnBodyPart < 1) exitWith {};

    {
        _x params ["_type", "_remainingVolume", "_accessType", "_accessSite", "_iv", "_bloodType", "_volume"];

        if (_accessSite != GVAR(TransfusionMenu_Selected_AccessSite) || _iv != GVAR(TransfusionMenu_SelectIV)) then {
            break;
        };

        private _bagIndex = count GVAR(TransfusionMenu_Selection_IVBags);

        GVAR(TransfusionMenu_Selection_IVBags) pushBack [_type, _remainingVolume, _accessType, _accessSite, _iv, _bloodType, _volume, _forEachIndex];

        private _itemClassName = [_type, _volume, _bloodType] call FUNC(formatFluidBagName);

        private _config = (configFile >> "CfgWeapons" >> _itemClassName);
        private _i = _ctrlBagPanel lbAdd getText (_config >> "displayName");
        _ctrlBagPanel lbSetPicture [_i, getText (_config >> "picture")];
        _ctrlBagPanel lbSetValue [_i, _bagIndex];
        _ctrlBagPanel lbSetTooltip [_i, (format [LLSTRING(TransfusionMenu_FluidRemaining), round(_remainingVolume)])];
    } forEach _IVBagsOnBodyPart;
} else {
    if (count GVAR(TransfusionMenu_Selection_IVBags) != count _IVBagsOnBodyPart) exitWith {
        [false] call FUNC(TransfusionMenu_UpdateBagList);
    };
    {
        _x params ["_type", "_remainingVolume", "_accessType", "_accessSite", "_iv", "_bloodType", "_volume"];

        if (_accessSite != GVAR(TransfusionMenu_Selected_AccessSite) || _iv != GVAR(TransfusionMenu_SelectIV)) then {
            break;
        };

        (GVAR(TransfusionMenu_Selection_IVBags) select _forEachIndex) params ["_cType", "_cRemainingVolume", "_cAccessType", "_cAccessSite", "_cIV", "_cBloodType", "_cVolume", "_cIndex"];

        if (_cIndex != _forEachIndex || _cType != _type || _cAccessType != _accessType || _cAccessSite != _accessSite || _cBloodType != _bloodType || _cVolume != _volume) exitWith {
            [false] call FUNC(TransfusionMenu_UpdateBagList);
        };

        if (_cRemainingVolume != _remainingVolume) then {
            GVAR(TransfusionMenu_Selection_IVBags) set [_forEachIndex, [_cType, _remainingVolume, _cAccessType, _cAccessSite, _cIV, _cBloodType, _cVolume, _cIndex]];
            _ctrlBagPanel lbSetTooltip [_forEachIndex, (format [LLSTRING(TransfusionMenu_FluidRemaining), round(_remainingVolume)])];
        };
    } forEach _IVBagsOnBodyPart;
};