#include "..\script_component.hpp"
/*
 * Author: Mighty
 * Module to call initHealTent through Zeus.
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC] call ACM_zeus_fnc_addFullHeal;
 *
 * Public: No
 */

params ["_logic"];

if !(local _logic) exitWith {};

private _unit = attachedTo _logic;

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
    case (isNull _unit): {
        [ACELSTRING(zeus,NothingSelected)] call _fnc_errorAndClose;
    };
    case (_unit isKindOf "Man" || {!(_unit isKindOf "Building")}): {
        [ACELSTRING(zeus,OnlyStructures)] call _fnc_errorAndClose;
    };
    case !(alive _unit): {
        [ACELSTRING(zeus,OnlyAlive)] call _fnc_errorAndClose;
    };
};

[_unit] call ACM_mission_fnc_initHealTent;

deleteVehicle _logic;