#include "..\script_component.hpp"
/*
 * Author: Blue
 * Do stuff on respawn.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Dead body <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [alive, body] call ACM_evacuation_fnc_onRespawn;
 *
 * Public: No
 */

params ["_unit", "_dead"];

if !(isMultiplayer) exitWith {};

if !(local _unit) exitWith {};

if !(isPlayer _unit) exitWith {};

_unit setVariable [QGVAR(playerSpawned), true];

[{ // Prevent restore loadout from breaking
    params ["_unit"];

    !isNull _unit;
},{
    params ["_unit"];

    if (["3denEnhanced"] call ACEFUNC(common,isModLoaded) && {_unit getVariable ["ENH_savedLoadout", -1] isNotEqualTo -1} && {(getUnitLoadout _unit) isNotEqualTo (_unit getVariable ["ENH_savedLoadout", -1])}) then {
        _unit setUnitLoadout (_unit getVariable ["ENH_savedLoadout", []]);
    };
}, [_unit], 30] call CBA_fnc_waitUntilAndExecute;