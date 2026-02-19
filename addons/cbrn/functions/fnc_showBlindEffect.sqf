#include "..\script_component.hpp"
/*
 * Author: Blue
 * Show blindness visual effect. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Is Active? <BOOL>
 * 2: Caused by camera change? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, true, false] call ACM_CBRN_fnc_showBlindEffect;
 *
 * Public: No
 */

params ["_patient", "_active", ["_cameraChange", false]];

if (ACE_player != _patient) exitWith {};

if (_active && (GVAR(blindnessEffectActive) || ACEGVAR(common,OldIsCamera))) exitWith {};

if (_active) then {
    GVAR(blindnessEffectActive) = true;
    EGVAR(core,ppBlindness) ppEffectEnable true;

    EGVAR(core,ppBlindness) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 1]];
    EGVAR(core,ppBlindness) ppEffectCommit 0;
    EGVAR(core,ppBlindness) ppEffectAdjust [0, 1, 0, [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1]];
    EGVAR(core,ppBlindness) ppEffectCommit ([3, 1] select _cameraChange);
} else {
    EGVAR(core,ppBlindness) ppEffectAdjust [1, 1, 0, [0, 0, 0, 1], [0, 0, 0, 0], [0, 0, 0, 0], [4, 4, 0, 0, 0, 0, 1]];
    EGVAR(core,ppBlindness) ppEffectCommit ([20, 3] select _cameraChange);

    GVAR(blindnessEffectActive) = false;
    
    [{
        if (GVAR(blindnessEffectActive)) exitWith {};
        EGVAR(core,ppBlindness) ppEffectEnable false;
    }, [], ([20, 3] select _cameraChange)] call CBA_fnc_waitAndExecute;
};