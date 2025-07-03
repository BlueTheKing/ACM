#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if unit can take off gas mask.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Can take off gas mask? <BOOL>
 *
 * Example:
 * [player] call ACM_CBRN_fnc_canTakeOffGasMask;
 *
 * Public: No
 */

params ["_unit"];

[_unit] call FUNC(isWearingGasMask);