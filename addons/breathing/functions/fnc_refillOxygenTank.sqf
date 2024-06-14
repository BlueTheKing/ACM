#include "..\script_component.hpp"
/*
 * Author: Blue
 * Refill empty oxygen tank in unit inventory.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_breathing_fnc_refillOxygenTank;
 *
 * Public: No
 */

params ["_unit"];

_unit call ACEFUNC(common,goKneeling);

_unit removeItem "ACM_OxygenTank_425_Empty";

[8, [_unit], {
    params ["_args"];
    _args params ["_unit"];

    [_unit, "ACM_OxygenTank_425"] call ACEFUNC(common,addToInventory);
    ["Oxygen Tank Refilled", 1.5, _unit] call ACEFUNC(common,displayTextStructured);
}, {
    params ["_args"];
    _args params ["_unit"];

    [_unit, "ACM_OxygenTank_425_Empty"] call ACEFUNC(common,addToInventory);
    ["Oxygen Tank Refilling Cancelled", 1.5, _unit] call ACEFUNC(common,displayTextStructured);
}, "Refilling Oxygen Tank..."] call ACEFUNC(common,progressBar);