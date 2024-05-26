#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module dialog to manually inflict chest injury
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [CONTROL] call ACM_zeus_fnc_inflictChestInjury;
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

private _fnc_onConfirm = {
    params [["_ctrlButtonOK", controlNull, [controlNull]]];

    private _display = ctrlParent _ctrlButtonOK;
    if (isNull _display) exitWith {};

    private _logic = GETMVAR(BIS_fnc_initCuratorAttributes_target,objNull);
    if (isNull _logic) exitWith {};

    private _patient = attachedTo _logic;

    private _selection = lbCurSel (_display displayCtrl IDC_MODULE_INFLICT_CHEST_INJURY_LIST);

    _patient setVariable [QEGVAR(breathing,ChestInjury_State), true, true];

    switch (_selection) do {
        case 0: {
            [_patient] call EFUNC(breathing,handlePneumothorax);
        };
        case 1: {
            _patient setVariable [QEGVAR(breathing,Pneumothorax_State), 4, true];
            [_patient] call EFUNC(breathing,handlePneumothorax);
        };
        case 2: {
            _patient setVariable [QEGVAR(breathing,Hemothorax_State), 2, true];
            [_patient] call EFUNC(breathing,handleHemothorax);
        };
        case 3: {
            _patient setVariable [QEGVAR(breathing,Hemothorax_State), 2, true];
            _patient setVariable [QEGVAR(breathing,Hemothorax_Fluid), 1.2, true];
            [_patient] call EFUNC(breathing,handleHemothorax);
        };
    };

    [_patient] call EFUNC(breathing,updateLungState);
};

_display displayAddEventHandler ["Unload", _fnc_onUnload];
_ctrlButtonOK ctrlAddEventHandler ["ButtonClick", _fnc_onConfirm];