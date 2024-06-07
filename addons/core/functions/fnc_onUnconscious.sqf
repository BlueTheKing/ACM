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
    [{
        params ["_patient"];

        _patient setVariable [QGVAR(WasTreated), false, true];
    }, [_patient], 2] call CBA_fnc_waitAndExecute;

    _patient setVariable [QEGVAR(breathing,BVM_lastBreath), -1, true];
};