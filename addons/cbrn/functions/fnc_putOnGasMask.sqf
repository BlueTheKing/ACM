#include "..\script_component.hpp"
/*
 * Author: Blue
 * Make target put on gas mask.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_putOnGasMask;
 *
 * Public: No
 */

params ["_target", ["_unit", objNull]];

private _gasMaskList = GVAR(PPE_List) get "gasmask";

private _index = _gasMaskList findIf {[_target, _x] call ACEFUNC(common,hasItem)};

if (_index < 0) exitWith {
    if !(isNull _unit) then {
        _index = _gasMaskList findIf {[_unit, _x] call ACEFUNC(common,hasItem)};

        if (_index < 0) exitWith {};

        private _classname = _gasMaskList select _index;

        _unit removeItem _classname;

        private _occupiedClassname = goggles _target;

        private _added = true;

        if (_occupiedClassname != "") then {
            _target unlinkItem _occupiedClassname;

            _added = ([_target, _occupiedClassname] call ACEFUNC(common,addToInventory)) select 0;
        };

        _target linkItem _classname;

        private _hint = LLSTRING(GasMask_Donned);
        private _hintSize = 1.5;

        if !(_added) then {
            _hint = format ["%1<br/>%2", _hint, LLSTRING(GasMask_DroppedFaceWear)];
            _hintSize = 2;
        };

        [_hint, _hintSize, _unit] call ACEFUNC(common,displayTextStructured);
    };
};

private _classname = _gasMaskList select _index;

_target removeItem _classname;

private _occupiedClassname = goggles _target;

private _added = true;

if (_occupiedClassname != "") then {
    _target unlinkItem _occupiedClassname;

    _added = ([_target, _occupiedClassname] call ACEFUNC(common,addToInventory)) select 0;
};

_target linkItem _classname;

private _hint = LLSTRING(GasMask_Donned);
private _hintSize = 1.5;

if !(_added) then {
    _hint = format ["%1<br/>%2", _hint, LLSTRING(GasMask_DroppedFaceWear)];
    _hintSize = 2;
};

[_hint, _hintSize, _target] call ACEFUNC(common,displayTextStructured);