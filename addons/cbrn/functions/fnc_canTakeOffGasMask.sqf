#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if unit can take off gas mask.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_canTakeOffGasMask;
 *
 * Public: No
 */

params ["_unit"];

(goggles _unit) in (GVAR(PPE_List) get "gasmask")