#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init circulation variables for unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_initUnit;
 */

params ["_unit"];

_unit setVariable [QGVAR(AmmoniaInhalant_EffectiveUses), (round(2 + random 3)), true];