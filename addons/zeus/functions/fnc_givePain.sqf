#include "..\script_component.hpp"
/*
 * Author: Blue
 * Give pain to patient.
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [CONTROL] call ACM_zeus_fnc_givePain;
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

private _ctrlPainAmount = _display displayCtrl IDC_MODULE_GIVE_PAIN_SLIDER;

private _patient = attachedTo _logic;

private _currentPain = GET_PAIN(_patient);

_ctrlPainAmount sliderSetPosition _currentPain;

private _fnc_sliderMove = {
    params ["_slider"];

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    private _patient = attachedTo _logic;
    
    private _currentValue = (GET_PAIN(_patient) toFixed 2);

    _slider ctrlSetTooltip format ["%1 (was %2)", (sliderPosition _slider), _currentValue];
};

private _slider = _display displayCtrl IDC_MODULE_GIVE_PAIN_SLIDER;
_slider ctrlAddEventHandler ["SliderPosChanged", _fnc_sliderMove];
_slider call _fnc_sliderMove;

private _fnc_onConfirm = {
    params [["_ctrlButtonOK", controlNull, [controlNull]]];

    private _display = ctrlParent _ctrlButtonOK;
    if (isNull _display) exitWith {};

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    private _patient = attachedTo _logic;

    private _currentPain = GET_PAIN(_patient);

    private _ctrlPainAmount = _display displayCtrl IDC_MODULE_GIVE_PAIN_SLIDER;

    private _setPain = (sliderPosition _ctrlPainAmount) - _currentPain;

    [QGVAR(givePain), [_patient, _setPain], _patient] call CBA_fnc_targetEvent;
};

_display displayAddEventHandler ["Unload", _fnc_onUnload];
_ctrlButtonOK ctrlAddEventHandler ["ButtonClick", _fnc_onConfirm];