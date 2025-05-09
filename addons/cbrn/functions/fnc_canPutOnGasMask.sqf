#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if unit can put on a gas mask.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Can put on gas mask? <BOOL>
 *
 * Example:
 * [player] call ACM_CBRN_fnc_canPutOnGasMask;
 *
 * Public: No
 */

params ["_unit"];

if ([_unit] call FUNC(isWearingGasMask)) exitWith {false};

[_unit] call FUNC(hasGasMask);