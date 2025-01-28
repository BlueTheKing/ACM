#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if unit has gas mask that can be worn.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_canPutOnGasMask;
 *
 * Public: No
 */

params ["_unit"];

private _gasMaskList = GVAR(PPE_List) get "gasmask";

if ((goggles _unit) in _gasMaskList) exitWith {false};

private _index = _gasMaskList findIf {[_unit, _x] call ACEFUNC(common,hasItem)};

_index > -1;