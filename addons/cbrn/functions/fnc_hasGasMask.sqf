#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if unit has gas mask in inventory.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Has gas mask? <BOOL>
 *
 * Example:
 * [player] call ACM_CBRN_fnc_hasGasMask;
 *
 * Public: No
 */

params ["_unit"];

if !(GVAR(enable)) exitWith {false};

private _gasMaskList = GVAR(PPE_List) get "gasmask";

private _index = _gasMaskList findIf {[_unit, _x] call ACEFUNC(common,hasItem)};

_index > -1;