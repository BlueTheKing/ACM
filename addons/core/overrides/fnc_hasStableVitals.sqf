#include "..\script_component.hpp"
/*
 * Author: Ruthberg
 * Check if a unit has stable vitals (required to become conscious)
 *
 * Arguments:
 * 0: The patient <OBJECT>
 *
 * Return Value:
 * Has stable vitals <BOOL>
 *
 * Example:
 * [player] call ace_medical_status_fnc_hasStableVitals
 *
 * Public: No
 */

params ["_unit"];

if (GET_BLOOD_VOLUME(_unit) < MINIMUM_BLOOD_FOR_STABLE_VITALS_DEFAULT) exitWith { /*systemchat format ["BLOOD %1",GET_BLOOD_VOLUME(_unit)];*/ false };
if IN_CRDC_ARRST(_unit) exitWith { false };
if ([_unit] call EFUNC(circulation,recentAEDShock)) exitWith { false };

private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);
private _bloodLoss = GET_BLOOD_LOSS(_unit);
if (_bloodLoss > (BLOOD_LOSS_KNOCK_OUT_THRESHOLD_DEFAULT * _cardiacOutput) / 2) exitWith { /*systemchat format ["BLOODLOSS %1 > %2",GET_BLOOD_VOLUME(_unit), (BLOOD_LOSS_KNOCK_OUT_THRESHOLD_DEFAULT * _cardiacOutput) / 2];*/ false };

private _bloodPressure = GET_BLOOD_PRESSURE(_unit);
_bloodPressure params ["_bloodPressureL", "_bloodPressureH"];
if (_bloodPressureL < 50 || {_bloodPressureH < 60}) exitWith { /*systemchat format ["BLOOD PRESSURE %1 < 50 || %2 < 60",_bloodPressureL, _bloodPressureH];*/ false };

private _heartRate = GET_HEART_RATE(_unit);
if (_heartRate < 40) exitWith { /*systemchat format ["HEART RATE %1",GET_HEART_RATE(_unit)];*/ false };

private _oxygen = GET_OXYGEN(_unit);
if (_oxygen < ACM_OXYGEN_UNCONSCIOUS) exitWith { /*systemchat format ["OXYGEN %1",GET_OXYGEN(_unit)];*/ false };

private _rr = GET_RESPIRATION_RATE(_unit);
if (_rr < 6) exitWith {/* systemchat format ["RESPIRATION RATE %1",GET_RESPIRATION_RATE(_unit)];*/ false };

true
