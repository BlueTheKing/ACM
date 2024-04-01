#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get SpO2 value, affected by oxygen saturation and blood loss
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Calculated Oxygen Saturation <NUMBER>
 *
 * Example:
 * [player] call AMS_breathing_fnc_getSpO2;
 *
 * Public: No
 */

params ["_patient"];

private _oxygen = GET_OXYGEN(_patient);
private _inaccuracyRange = linearConversion [95, 75, _oxygen, 1, 5, false];
private _bloodLossEffect = linearConversion [5.5, 3, GET_BLOOD_VOLUME(_patient), 0, 25, true];

(random [(0 max (_oxygen - _inaccuracyRange)), _oxygen, ((_oxygen + _inaccuracyRange) min 99)]) - (_bloodLossEffect * (_oxygen / (_patient getVariable [QEGVAR(core,TargetVitals_OxygenSaturation), 100])));