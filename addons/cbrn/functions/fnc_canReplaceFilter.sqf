#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if unit has gas mask filter.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_canReplaceFilter;
 *
 * Public: No
 */

params ["_unit"];

if !([_unit, "ACM_GasMaskFilter"] call ACEFUNC(common,hasItem)) exitWith {false};

private _gasMaskList = GVAR(PPE_List) get "gasmask";

if ((goggles _unit) in _gasMaskList) exitWith {true};

private _index = _gasMaskList findIf {[_unit, _x] call ACEFUNC(common,hasItem)};

_index > -1;