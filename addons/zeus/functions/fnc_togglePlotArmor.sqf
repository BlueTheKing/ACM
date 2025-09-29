#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to toggle instant death on unit.
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC] call ACM_zeus_fnc_togglePlotArmor;
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

private _immune = _unit getVariable [QEGVAR(damage,InstantDeathImmune), false];

_immune = !_immune;

_unit setVariable [QEGVAR(damage,InstantDeathImmune), _immune, true];
_unit setVariable [QACEGVAR(medical_statemachine,AIUnconsciousness), _immune, true];

[([LLSTRING(Module_PlotArmor_Disabled), LLSTRING(Module_PlotArmor_Enabled)] select _immune)] call ACEFUNC(zeus,showMessage);

deleteVehicle _logic;
