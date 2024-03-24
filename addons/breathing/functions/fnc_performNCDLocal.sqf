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
 * [player, cursorTarget] call AMS_breathing_fnc_performNCDLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

_patient setVariable [QGVAR(TensionPneumothorax_State), false];

if (_patient getVariable [QGVAR(Pneumothorax_State), 0] > 0) then {
    _patient setVariable [QGVAR(Pneumothorax_State), 0];

    if !(_patient getVariable [QGVAR(ChestSeal_State), false]) then {
        [_patient] call FUNC(handlePneumothorax);
    } else {
        [_patient] call FUNC(updateBreathingState);
    };
} else {
    [_patient] call FUNC(updateBreathingState);
};