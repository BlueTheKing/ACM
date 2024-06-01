#include "..\script_component.hpp"
/*
 * Author: Blue
 * Find if medic has syringe in inventory
 *
 * Arguments:
 * 0: Medic <OBJECT>
 *
 * Return Value:
 * Found syringe? <BOOL>
 *
 * Example:
 * [player] call ACM_circulation_fnc_Syringe_Find;
 *
 * Public: No
 */

params ["_medic"];

private _cachedItems = [_medic, 0] call ACEFUNC(common,uniqueItems);

private _index = ['ACM_Syringe_IM','ACM_Syringe_IM_Epinephrine','ACM_Syringe_IM_Morphine','ACM_Syringe_IM_Lidocaine'] findIf {_x in _cachedItems};

if (_index != -1) exitWith {true};

false;