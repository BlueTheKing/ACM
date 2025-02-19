#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to create chemical device on object.
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [CONTROL] call ACM_CBRN_fnc_moduleCreateChemicalDevice;
 *
 * Public: No
 */

params ["_control"];

// Generic init
private _display = ctrlParent _control;
private _ctrlButtonOK = _display displayCtrl 1; // IDC_OK
private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
TRACE_1("Logic Object",_logic);

_control ctrlRemoveAllEventHandlers "SetFocus";

private _attachedObject = attachedTo _logic;

// Validate module target
scopeName "Main";
private _fnc_errorAndClose = {
    params ["_msg"];

    _display closeDisplay 0;
    deleteVehicle _logic;
    [_msg] call ACEFUNC(zeus,showMessage);
    breakOut "Main";
};

switch (true) do {
    case (isNull _attachedObject): {
        [LLSTRING(Module_Generic_Error_SelectObject)] call _fnc_errorAndClose;
    };
    case !(alive _attachedObject): {
        [LLSTRING(Module_Generic_Error_NotDestroyed)] call _fnc_errorAndClose;
    };
};

private _fnc_onUnload = {
    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    deleteVehicle _logic;
};

private _fnc_sliderMove = {
    params ["_slider"];

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    _slider ctrlSetTooltip format ["%1%%", (sliderPosition _slider)];
};

private _fnc_radiusSliderMove = {
    params ["_slider"];

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    _slider ctrlSetTooltip format ["%1m", (sliderPosition _slider)];
};

private _sliderRadius = _display displayCtrl IDC_MODULE_CREATE_CHEMICALDEVICE_RADIUS;
_sliderRadius ctrlAddEventHandler ["SliderPosChanged", _fnc_radiusSliderMove];
_sliderRadius call _fnc_radiusSliderMove;

private _fnc_onConfirm = {
    params [["_ctrlButtonOK", controlNull, [controlNull]]];

    private _display = ctrlParent _ctrlButtonOK;
    if (isNull _display) exitWith {};

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    private _attachedObject = attachedTo _logic;

    private _hazardTypeSelection = lbCurSel (_display displayCtrl IDC_MODULE_CREATE_CHEMICALDEVICE_LIST);
    private _hazardType = ["chemical_chlorine","chemical_sarin","chemical_lewisite"] select _hazardTypeSelection;

    private _cloudSizeSelection = lbCurSel (_display displayCtrl IDC_MODULE_CREATE_CHEMICALDEVICE_CLOUDSIZELIST);
    private _radius = sliderPosition (_display displayCtrl IDC_MODULE_CREATE_CHEMICALDEVICE_RADIUS);
    private _effectTime = [(20 + (random 15)), -1] select (cbChecked (_display displayCtrl IDC_MODULE_CREATE_CHEMICALDEVICE_PERMANENT));
    private _affectAI = cbChecked (_display displayCtrl IDC_MODULE_CREATE_CHEMICALDEVICE_AFFECTAI);
    
    [{
        params ["_attachedObject"];

        isNull _attachedObject || !(alive _attachedObject);
    }, {
        params ["_attachedObject", "_hazardType", "_radius", "_effectTime", "_affectAI", "_cloudSizeSelection"];

        if (isNull _attachedObject) exitWith {};

        [_attachedObject, _hazardType, _radius, _effectTime, _affectAI, _cloudSizeSelection] call FUNC(detonateChemicalDevice);
    }, [_attachedObject, _hazardType, _radius, _effectTime, _affectAI, _cloudSizeSelection], 3600] call CBA_fnc_waitUntilAndExecute;
};

_display displayAddEventHandler ["Unload", _fnc_onUnload];
_ctrlButtonOK ctrlAddEventHandler ["ButtonClick", _fnc_onConfirm];