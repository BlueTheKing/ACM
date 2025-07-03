#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if unit can replace gas mask filter.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Can replace filter? <BOOL>
 *
 * Example:
 * [player] call ACM_CBRN_fnc_canReplaceFilter;
 *
 * Public: No
 */

params ["_unit"];

if !([_unit] call FUNC(hasFilter)) exitWith {false};

if (_unit call FUNC(isWearingGasMask)) exitWith {true};

[_unit] call FUNC(hasGasMask);