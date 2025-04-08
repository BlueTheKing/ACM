#include "..\script_component.hpp"
/*
 * Author: Blue
 * Show blindness visual effect.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Is Active? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, true] call ACM_CBRN_fnc_setBlind;
 *
 * Public: No
 */

params ["_patient", "_active"];

[QGVAR(showBlindEffect), [_patient, _active], _patient] call CBA_fnc_targetEvent;

if (_active) then {
    [{
        params ["_patient"];

        _patient setVariable [QGVAR(Blindness_State), true, true];
    }, [_patient], 1] call CBA_fnc_waitAndExecute;
} else {
    [{
        params ["_patient"];

        _patient setVariable [QGVAR(Blindness_State), false, true];
    }, [_patient], 6] call CBA_fnc_waitAndExecute;
};