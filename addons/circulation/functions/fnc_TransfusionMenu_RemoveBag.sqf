#include "..\script_component.hpp"
#include "..\TransfusionMenu_defines.hpp"
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

private _fnc_completeRemoval = {
    params ["_IVBags", "_IVBagsOnBodyPart", "_targetIndex", "_itemClassName", "_type", "_returnVolume", "_totalVolume"];

    private _returned = true;

    if (_returnVolume > 0) then {
        if (_type == "FBTK" && _returnVolume >= 250) then {
            private _className = ["FreshBlood", _returnVolume] call FUNC(formatFluidBagName);
            private _freshBloodID = [GVAR(TransfusionMenu_Target), _returnVolume] call FUNC(generateFreshBloodEntry);
            _returned = [ACE_player, (format ["%1_%2", _className, _freshBloodID])] call ACEFUNC(common,addToInventory);
        } else {
            _returned = [ACE_player, _itemClassName] call ACEFUNC(common,addToInventory);
        };
    } else {
        if (_type == "FBTK") then {
            _returned = [ACE_player, (format ["ACM_FieldBloodTransfusion_%1", _totalVolume])] call ACEFUNC(common,addToInventory);
        };
    };

    _returned = (_returned select 0);

    if !(_returned) then {
        [ACELLSTRING(common,Inventory_Full), 1.5, ACE_player] call ACEFUNC(common,displayTextStructured);
    };

    _IVBagsOnBodyPart deleteAt _targetIndex;
    _IVBags set [GVAR(TransfusionMenu_Selected_BodyPart), _IVBagsOnBodyPart];

    GVAR(TransfusionMenu_Target) setVariable [QGVAR(IV_Bags), _IVBags, true];
};

private _targetIndex = (GVAR(TransfusionMenu_Selection_IVBags) select _selectionIndex) select 8;

private _IVBags = GVAR(TransfusionMenu_Target) getVariable [QGVAR(IV_Bags), createHashMap];
private _IVBagsOnBodyPart = _IVBags getOrDefault [GVAR(TransfusionMenu_Selected_BodyPart), []];

private _bagContents = +(_IVBagsOnBodyPart select _targetIndex);

_bagContents params ["_type", "_remainingVolume", "_accessType", "_accessSite", "_iv", "_bloodType", "_volume"];

private _returnVolume = [_remainingVolume] call FUNC(getReturnVolume);

private _itemClassName = [_type, _returnVolume, _bloodType] call FUNC(formatFluidBagName);
private _itemClassNameString = getText (configFile >> "CfgWeapons" >> _itemClassName >> "displayName");

private _funcParams = [_IVBags, _IVBagsOnBodyPart, _targetIndex, _itemClassName, _type, _returnVolume, _volume];

[[ACE_player, GVAR(TransfusionMenu_Target), _type, _returnVolume, _bloodType, _fnc_completeRemoval, _funcParams], {
    params ["_medic", "_patient", "_type", "_returnVolume", "_bloodType", "_fnc_completeRemoval", "_funcParams"];
    
    _funcParams call _fnc_completeRemoval;

    private _fluidBagString = "";

    if (_type == "FBTK") then {
        _fluidBagString = format ["%1 %2ml", "FBTK", _returnVolume];
    } else {
        _fluidBagString = [([_type, _returnVolume, _bloodType, true] call FUNC(formatFluidBagName))] call FUNC(getFluidBagString);
    };
    [_patient, "activity", LSTRING(TransfusionMenu_RemoveBag_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), (_fluidBagString), ([GVAR(TransfusionMenu_Selected_BodyPart)] call EFUNC(core,getBodyPartString))]] call ACEFUNC(medical_treatment,addToLog);
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