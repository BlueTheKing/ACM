#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to create hazard zone.
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [CONTROL] call ACM_CBRN_fnc_moduleCreateHazardZone;
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

// Validate module target
scopeName "Main";
private _fnc_errorAndClose = {
    params ["_msg"];

    _display closeDisplay 0;
    deleteVehicle _logic;
    [_msg] call ACEFUNC(zeus,showMessage);
    breakOut "Main";
};

if !(GVAR(enable)) then {
    [LLSTRING(Module_Generic_Error_AddonDisabled)] call _fnc_errorAndClose;
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

private _fnc_timeSliderMove = {
    params ["_slider"];

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    _slider ctrlSetTooltip format ["%1 minutes", (sliderPosition _slider)];
};

private _fnc_radiusSliderMove = {
    params ["_slider"];

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    _slider ctrlSetTooltip format ["%1m", (sliderPosition _slider)];
};

private _sliderRadius = _display displayCtrl IDC_MODULE_CREATE_HAZARDZONE_RADIUS;
_sliderRadius ctrlAddEventHandler ["SliderPosChanged", _fnc_radiusSliderMove];
_sliderRadius call _fnc_radiusSliderMove;

private _sliderEffectTime = _display displayCtrl IDC_MODULE_CREATE_HAZARDZONE_EFFECTTIME;
_sliderEffectTime ctrlAddEventHandler ["SliderPosChanged", _fnc_timeSliderMove];
_sliderEffectTime call _fnc_timeSliderMove;

private _fnc_onConfirm = {
    params [["_ctrlButtonOK", controlNull, [controlNull]]];

    private _display = ctrlParent _ctrlButtonOK;
    if (isNull _display) exitWith {};

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    private _attachedObject = attachedTo _logic;
    private _attach = (cbChecked (_display displayCtrl IDC_MODULE_CREATE_HAZARDZONE_ATTACH)) && !(isNull _attachedObject); 
    private _targetObject = [_logic, _attachedObject] select _attach;

    private _hazardTypeSelection = lbCurSel (_display displayCtrl IDC_MODULE_CREATE_HAZARDZONE_LIST);
    private _hazardType = switch (_hazardTypeSelection) do {
        case 1: {"chemical_cs"};
        case 2: {"chemical_chlorine"};
        case 3: {"chemical_sarin"};
        case 4: {"chemical_lewisite"};
        default {"chemical_placebo"};
    };

    private _radius = sliderPosition (_display displayCtrl IDC_MODULE_CREATE_HAZARDZONE_RADIUS);
    private _showMist = cbChecked (_display displayCtrl IDC_MODULE_CREATE_HAZARDZONE_SHOWMIST);
    private _affectAI = cbChecked (_display displayCtrl IDC_MODULE_CREATE_HAZARDZONE_AFFECTAI);

    private _effectTime = sliderPosition (_display displayCtrl IDC_MODULE_CREATE_HAZARDZONE_EFFECTTIME);
    _effectTime = [-1, (_effectTime * 60)] select (_effectTime > 0);

    [QGVAR(initHazardZone), [_targetObject, _attach, _hazardType, [_radius,_radius,0,false,-1], _effectTime, _affectAI, true, _showMist, ACE_player]] call CBA_fnc_serverEvent;
};

_display displayAddEventHandler ["Unload", _fnc_onUnload];
_ctrlButtonOK ctrlAddEventHandler ["ButtonClick", _fnc_onConfirm];