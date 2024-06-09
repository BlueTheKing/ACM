#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient unconscious event
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Unconscious State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, true] call ACM_core_fnc_onUnconscious;
 *
 * Public: No
 */

params ["_patient", "_state"];

if (!local _patient) exitWith {};

if !(_state) then {
    if (_patient getVariable [QGVAR(WasTreated), false]) then {
        _patient setVariable [QGVAR(Lying_State), true, true];
        _patient setVariable [QGVAR(WasTreated), false, true];
    };

    if ((_patient getVariable [QGVAR(Lying_State), false]) && ((animationState _patient) in LYING_ANIMATION)) then {
        [QGVAR(getUpPrompt), [_patient], _patient] call CBA_fnc_targetEvent;
    };

    _patient setVariable [QEGVAR(breathing,BVM_lastBreath), -1, true];
} else {
    [_patient] call ACEFUNC(weaponselect,putWeaponAway);
};