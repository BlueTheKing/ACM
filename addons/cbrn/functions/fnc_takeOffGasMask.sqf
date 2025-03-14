#include "..\script_component.hpp"
/*
 * Author: Blue
 * Make unit take off gas mask.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_takeOffGasMask;
 *
 * Public: No
 */

params ["_unit"];

private _classname = goggles _unit;

_unit unlinkItem _classname;

private _added = ([_unit, _classname] call ACEFUNC(common,addToInventory)) select 0;

private _hint = LLSTRING(GasMask_Removed);
private _hintSize = 1.5;

if !(_added) then {
    _hint = format ["%1<br/>%2", _hint, ACELLSTRING(common,Inventory_Full)];
    _hintSize = 2;
};

[_hint, _hintSize, _unit] call ACEFUNC(common,displayTextStructured);