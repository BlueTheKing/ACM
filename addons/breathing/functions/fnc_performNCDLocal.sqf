#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform needle chest decompression on patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_performNCDLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[_patient, 0.5] call ACEFUNC(medical,adjustPainLevel);

if (_patient getVariable [QGVAR(TensionPneumothorax_State), false]) then {
    _patient setVariable [QGVAR(TensionPneumothorax_State), false, true];

    if (_patient getVariable [QGVAR(Pneumothorax_State), 0] > 0) then {
        _patient setVariable [QGVAR(Pneumothorax_State), 0, true];

        if !(_patient getVariable [QGVAR(ChestSeal_State), false]) then {
            [_patient] call FUNC(handlePneumothorax);
        } else {
            [_patient] call FUNC(updateBreathingState);
        };
    } else {
        [_patient] call FUNC(updateBreathingState);
    };
} else {
    if !(_patient getVariable [QGVAR(ChestSeal_State), false]) then {
        _patient setVariable [QGVAR(Pneumothorax_State), 3, true];
    };
};