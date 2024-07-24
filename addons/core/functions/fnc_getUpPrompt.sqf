#include "..\script_component.hpp"
/*
 * Author: Blue
 * Give interactions to get up
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_getUpPrompt;
 *
 * Public: No
 */

params ["_unit"];

if (ACE_player != _unit) exitWith {};

["Get up", "", ""] call ACEFUNC(interaction,showMouseHint);

_unit setVariable [QGVAR(GetUpActionID), [0xF0, [false, false, false], {
    ACE_player call FUNC(getUp);
}, "keyup", "", false, 0] call CBA_fnc_addKeyHandler];

[{
    params ["_unit"];

    !(_unit getVariable [QGVAR(Lying_State), false]) || IS_UNCONSCIOUS(_unit) || (animationState _unit == "AinjPfalMstpSnonWnonDf_carried_dead");
}, {
    params ["_unit"];

    if (!(animationState _unit == "AinjPfalMstpSnonWnonDf_carried_dead") || IS_UNCONSCIOUS(_unit)) then {
        [] call ACEFUNC(interaction,hideMouseHint);
    };
    [_unit getVariable QGVAR(GetUpActionID), "keyup"] call CBA_fnc_removeKeyHandler;
    _unit setVariable [QGVAR(GetUpActionID), nil];
}, [_unit], 3600, {}] call CBA_fnc_waitUntilAndExecute;
