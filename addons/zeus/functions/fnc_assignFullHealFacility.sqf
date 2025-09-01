#include "..\script_component.hpp"
/*
 * Author: Mighty
 * Module to assign full heal facility.
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC] call ACM_zeus_fnc_assignFullHealFacility;
 *
 * Public: No
 */

params ["_logic"];

if !(local _logic) exitWith {};

private _object = attachedTo _logic;

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
    case (isNull _object): {
        [ACELSTRING(zeus,NothingSelected)] call _fnc_errorAndClose;
    };
    case (_object isKindOf "Man" || {!(_object isKindOf "Building")}): {
        [ACELSTRING(zeus,OnlyStructures)] call _fnc_errorAndClose;
    };
    case !(alive _object): {
        [ACELSTRING(zeus,OnlyAlive)] call _fnc_errorAndClose;
    };
};

[QEGVAR(mission,initFullHealFacility), [_object]] call CBA_fnc_globalEvent;

deleteVehicle _logic;