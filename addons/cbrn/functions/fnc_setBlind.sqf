#include "..\script_component.hpp"
/*
 * Author: Blue
 * Show blindness visual effect. (LOCAL)
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

if (_active && GVAR(blindnessEffectActive)) exitWith {};

if (_active) then {
    GVAR(blindnessEffectActive) = true;
    EGVAR(core,ppBlindness) ppEffectEnable true;

    EGVAR(core,ppBlindness) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 1]];
    EGVAR(core,ppBlindness) ppEffectCommit 0;
    EGVAR(core,ppBlindness) ppEffectAdjust [0, 1, 0, [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
    EGVAR(core,ppBlindness) ppEffectCommit 3;

    [{
        params ["_patient"];

        _patient setVariable [QGVAR(Blindness_State), true, true];
    }, [_patient], 1] call CBA_fnc_waitAndExecute;
} else {
    EGVAR(core,ppBlindness) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0], [4, 4, 0, 0, 0, 0, 1]];
    EGVAR(core,ppBlindness) ppEffectCommit 20;
    
    [{
        params ["_patient"];

        GVAR(blindnessEffectActive) = false;
        _patient setVariable [QGVAR(Blindness_State), false, true];
        EGVAR(core,ppBlindness) ppEffectEnable false;
    }, [_patient], 25] call CBA_fnc_waitAndExecute;
};