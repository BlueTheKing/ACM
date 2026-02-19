#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if unit has filter in inventory.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Has filter? <BOOL>
 *
 * Example:
 * [player] call ACM_CBRN_fnc_hasFilter;
 *
 * Public: No
 */

params ["_unit"];

[_unit, "ACM_GasMaskFilter"] call ACEFUNC(common,hasItem);