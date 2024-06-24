#include "..\script_component.hpp"
/*
 * Author: Blue
 * Find if medic has syringe in inventory
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: IV? <BOOL>
 *
 * Return Value:
 * Found syringe? <BOOL>
 *
 * Example:
 * [player, false] call ACM_circulation_fnc_Syringe_Find;
 *
 * Public: No
 */

params ["_medic", ["_iv", false]];

private _cachedItems = [_medic, 1] call ACEFUNC(common,uniqueItems);

private _index = ([ACM_SYRINGES_IM, ACM_SYRINGES_IV] select _iv) findIf {_x in _cachedItems};

if (_index != -1) exitWith {true};

false;