#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get SpO2 value, affected by oxygen saturation and blood loss
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Is Accurate <BOOL>
 *
 * Return Value:
 * Calculated Oxygen Saturation <NUMBER>
 *
 * Example:
 * [player, false] call ACM_breathing_fnc_getSpO2;
 *
 * Public: No
 */

params ["_patient", ["_accurate", false]];

private _oxygen = GET_OXYGEN(_patient);
private _inaccuracyRange = linearConversion [95, 75, _oxygen, 1, 5, false];
private _bloodLossEffect = linearConversion [5.5, 3, GET_BLOOD_VOLUME(_patient), 0, 25, true];

if (!(alive _patient) || GET_HEART_RATE(_patient) < 20) exitWith {0};

if !(_accurate) exitWith {
    (random [(0 max (_oxygen - _inaccuracyRange)), _oxygen, ((_oxygen + _inaccuracyRange) min 99)]) - (_bloodLossEffect * (_oxygen / ACM_TARGETVITALS_OXYGEN(_patient)));
};

(_oxygen - (_bloodLossEffect * (_oxygen / ACM_TARGETVITALS_OXYGEN(_patient))));