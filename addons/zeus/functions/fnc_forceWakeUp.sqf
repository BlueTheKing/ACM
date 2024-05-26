#include "..\script_component.hpp"
/*
 * Author: Blue
 * Force wake up patient
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC] call ACM_zeus_fnc_forceWakeUp;
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

if (IN_CRDC_ARRST(_unit)) then {
    [QACEGVAR(medical,CPRSucceeded), [_unit], _unit] call CBA_fnc_targetEvent;
};

[QGVAR(forceWakeUp), [_unit], _unit] call CBA_fnc_targetEvent;

deleteVehicle _logic;
