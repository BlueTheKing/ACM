#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module dialog to modify patient state
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [CONTROL] call ACM_zeus_fnc_setBloodVolume;
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

private _unit = effectiveCommander attachedTo _logic;

// Validate module target
scopeName "Main";
private _fnc_errorAndClose = {
    params ["_msg"];
    deleteVehicle _logic;
    [_msg] call ACEFUNC(zeus,showMessage);
    breakOut "Main";
};

switch (true) do {
    case (isNull _unit): {
        [ACELSTRING(zeus,NothingSelected)] call _fnc_errorAndClose;
    };
    case !(_unit isKindOf "CAManBase"): {
        [ACELSTRING(zeus,OnlyInfantry)] call _fnc_errorAndClose;
    };
    case !(alive _unit): {
        [ACELSTRING(zeus,OnlyAlive)] call _fnc_errorAndClose;
    };
};


private _fnc_onUnload = {
    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    deleteVehicle _logic;
};

private _ctrlBloodVolume = _display displayCtrl IDC_MODULE_SET_BLOOD_VOLUME_BLOODVOLUME;
private _ctrlPlasmaVolume = _display displayCtrl IDC_MODULE_SET_BLOOD_VOLUME_PLASMAVOLUME;
private _ctrlSalineVolume = _display displayCtrl IDC_MODULE_SET_BLOOD_VOLUME_SALINEVOLUME;

private _patient = attachedTo _logic;

private _currentBloodVolume = _patient getVariable [QEGVAR(circulation,Blood_Volume), 6];
private _currentPlasmaVolume = _patient getVariable [QEGVAR(circulation,Plasma_Volume), 0];
private _currentSalineVolume = _patient getVariable [QEGVAR(circulation,Saline_Volume), 0];

_ctrlBloodVolume sliderSetPosition _currentBloodVolume;
_ctrlPlasmaVolume sliderSetPosition _currentPlasmaVolume;
_ctrlSalineVolume sliderSetPosition _currentSalineVolume;

private _fnc_sliderMove = {
    params ["_slider"];

    private _idcIndex = (ctrlIDC _slider) - IDC_MODULE_SET_BLOOD_VOLUME_BLOODVOLUME;

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    private _patient = attachedTo _logic;
    
    private _currentValue = switch (_idcIndex) do {
        case 0: {_patient getVariable [QEGVAR(circulation,Blood_Volume), 6];};
        case 1: {_patient getVariable [QEGVAR(circulation,Plasma_Volume), 0];};
        case 2: {_patient getVariable [QEGVAR(circulation,Saline_Volume), 0];};
    };

    _slider ctrlSetTooltip format ["%1%3 (was %2%3)", (sliderPosition _slider), _currentValue, "L"];
};

{
    private _slider = _display displayCtrl _x;
    _slider ctrlAddEventHandler ["SliderPosChanged", _fnc_sliderMove];
    _slider call _fnc_sliderMove;
} forEach [IDC_MODULE_SET_BLOOD_VOLUME_BLOODVOLUME,IDC_MODULE_SET_BLOOD_VOLUME_PLASMAVOLUME,IDC_MODULE_SET_BLOOD_VOLUME_SALINEVOLUME];

private _fnc_onConfirm = {
    params [["_ctrlButtonOK", controlNull, [controlNull]]];

    private _display = ctrlParent _ctrlButtonOK;
    if (isNull _display) exitWith {};

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    private _patient = attachedTo _logic;

    private _ctrlBloodVolume = _display displayCtrl IDC_MODULE_SET_BLOOD_VOLUME_BLOODVOLUME;
    private _ctrlPlasmaVolume = _display displayCtrl IDC_MODULE_SET_BLOOD_VOLUME_PLASMAVOLUME;
    private _ctrlSalineVolume = _display displayCtrl IDC_MODULE_SET_BLOOD_VOLUME_SALINEVOLUME;

    private _bloodVolume = sliderPosition _ctrlBloodVolume;
    private _plasmaVolume = sliderPosition _ctrlPlasmaVolume;
    private _salineVolume = sliderPosition _ctrlSalineVolume;

    _patient setVariable [QEGVAR(circulation,Blood_Volume), _bloodVolume, true];
    _patient setVariable [QEGVAR(circulation,Plasma_Volume), _plasmaVolume, true];
    _patient setVariable [QEGVAR(circulation,Saline_Volume), _salineVolume, true];
};

_display displayAddEventHandler ["Unload", _fnc_onUnload];
_ctrlButtonOK ctrlAddEventHandler ["ButtonClick", _fnc_onConfirm];