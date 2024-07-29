#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
/*
 * Author: Blue
 * Handle remove bag button.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_circulation_fnc_TransfusionMenu_RemoveBag;
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(TransfusionMenu_DLG), displayNull];

private _ctrlBagPanel = _display displayCtrl IDC_TRANSFUSIONMENU_LEFTLISTPANEL;

private _selectionIndex = lbCurSel _ctrlBagPanel;

if (_selectionIndex < 0) exitWith {};

private _completeRemoval = {
    params ["_IVBags", "_IVBagsOnBodyPart", "_targetIndex", "_itemClassName", "_return"];

    if (_return) then {
        [ACE_player, _itemClassName] call ACEFUNC(common,addToInventory);
    };

    _IVBagsOnBodyPart deleteAt _targetIndex;
    _IVBags set [GVAR(TransfusionMenu_Selected_BodyPart), _IVBagsOnBodyPart];

    GVAR(TransfusionMenu_Target) setVariable [QGVAR(IV_Bags), _IVBags, true];
};

private _targetIndex = (GVAR(TransfusionMenu_Selection_IVBags) select _selectionIndex) select 7;

private _IVBags = GVAR(TransfusionMenu_Target) getVariable [QGVAR(IV_Bags), createHashMap];
private _IVBagsOnBodyPart = _IVBags getOrDefault [GVAR(TransfusionMenu_Selected_BodyPart), []];

private _bagContents = +(_IVBagsOnBodyPart select _targetIndex);

_bagContents params ["_type", "_remainingVolume", "_accessType", "_accessSite", "_iv", "_bloodType", "_volume"];

private _returnVolume = 0;

if (_remainingVolume < 1000) then {
    if (_remainingVolume < 500) then {
        if !(_remainingVolume < 250) then {
            _returnVolume = 250;
        };
    } else {
        _returnVolume = 500;
    };
} else {
    _returnVolume = 1000;
};

private _itemClassName = ([([true, _type, _returnVolume] call FUNC(getFluidBagConfigName)), ([false, _type, _returnVolume, _bloodType] call FUNC(getFluidBagConfigName))] select (_type == "Blood"));
private _itemClassNameString = getText (configFile >> "CfgWeapons" >> _itemClassName >> "displayName");

private _funcParams = [_IVBags, _IVBagsOnBodyPart, _targetIndex, _itemClassName, (_returnVolume > 0)];

[[ACE_player, GVAR(TransfusionMenu_Target), _type, _returnVolume, _bloodType, _completeRemoval, _funcParams], {
    params ["_medic", "_patient", "_type", "_returnVolume", "_bloodType", "_completeRemoval", "_funcParams"];
    
    _funcParams call _completeRemoval;
    private _fluidBagString = [([([true, _type, _returnVolume, -1, true] call FUNC(getFluidBagConfigName)), ([false, _type, _returnVolume, _bloodType, true] call FUNC(getFluidBagConfigName))] select (_type == "Blood"))] call EFUNC(core,getFluidBagString);
    [_patient, "activity", LSTRING(TransfusionMenu_RemoveBag_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _fluidBagString, ([GVAR(TransfusionMenu_Selected_BodyPart)] call EFUNC(core,getBodyPartString))]] call ACEFUNC(medical_treatment,addToLog);
    closeDialog 0;
    
    [{
        params ["_medic", "_patient"];

        [_medic, _patient, GVAR(TransfusionMenu_Selected_BodyPart)] call FUNC(openTransfusionMenu);
    }, [_medic, _patient], 0.05] call CBA_fnc_waitAndExecute;
}, {
    params ["_medic", "_patient"];
    closeDialog 0;
    
    [_medic, _patient, GVAR(TransfusionMenu_Selected_BodyPart)] call FUNC(openTransfusionMenu);
}, (format [LLSTRING(TransfusionMenu_RemoveBag_Progress), _itemClassNameString]), 2.5] call EFUNC(core,progressBarAction);