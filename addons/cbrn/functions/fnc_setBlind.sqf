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

_patient setVariable [QGVAR(Blindness_State), _active, true];