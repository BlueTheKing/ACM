#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_core_fnc_initUnit;
 */

params ["_unit"];

[_unit] call EFUNC(circulation,generateBloodType);