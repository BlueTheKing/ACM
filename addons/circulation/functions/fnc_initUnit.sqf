#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init circulation variables for unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_initUnit;
 *
 * Public: No
 */

params ["_unit"];

if (_unit == ACE_player) then {
    _patient setVariable [QGVAR(AnestheticEffect_Ketamine_Absorbed), false];
};