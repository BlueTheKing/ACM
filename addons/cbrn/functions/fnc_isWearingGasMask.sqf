#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if unit is wearing a gas mask.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_isWearingGasMask;
 *
 * Public: No
 */

params ["_unit"];

if !(GVAR(enable)) exitWith {false};

(goggles _unit) in (GVAR(PPE_List) get "gasmask")