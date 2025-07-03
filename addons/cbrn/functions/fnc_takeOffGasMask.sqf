#include "..\script_component.hpp"
/*
 * Author: Blue
 * Make target take off gas mask.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_takeOffGasMask;
 *
 * Public: No
 */

params ["_target", ["_unit", objNull]];

private _classname = goggles _target;

_target unlinkItem _classname;

private _hint = LLSTRING(GasMask_Removed);
private _hintSize = 1.5;

if !(isNull _unit) exitWith {
    private _added = ([_unit, _classname] call ACEFUNC(common,addToInventory)) select 0;

    if !(_added) then {
        _hint = format ["%1<br/>%2", _hint, ACELLSTRING(common,Inventory_Full)];
        _hintSize = 2;
    };

    [_hint, _hintSize, _unit] call ACEFUNC(common,displayTextStructured);
};

private _added = ([_target, _classname] call ACEFUNC(common,addToInventory)) select 0;

if !(_added) then {
    _hint = format ["%1<br/>%2", _hint, ACELLSTRING(common,Inventory_Full)];
    _hintSize = 2;
};

[_hint, _hintSize, _target] call ACEFUNC(common,displayTextStructured);