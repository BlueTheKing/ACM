#include "..\script_component.hpp"
/*
 * Author: Blue
 * Find if medic has syringe in inventory
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Size <NUMBER>
 *
 * Return Value:
 * Found syringe? <BOOL>
 *
 * Example:
 * [player, 0] call ACM_circulation_fnc_Syringe_Find;
 *
 * Public: No
 */

params ["_medic", ["_size", 0]];

private _cachedItems = [_medic, 1] call ACEFUNC(common,uniqueItems);

private _array = switch (_size) do {
    case 10: {ACM_SYRINGES_10};
    case 5: {ACM_SYRINGES_5};
    case 3: {ACM_SYRINGES_3};
    case 1: {ACM_SYRINGES_1};
    default {ACM_SYRINGES_10 + ACM_SYRINGES_5 + ACM_SYRINGES_3 + ACM_SYRINGES_1};
};

private _index = _array findIf {_x in _cachedItems};

if (_index != -1) exitWith {true};

false;