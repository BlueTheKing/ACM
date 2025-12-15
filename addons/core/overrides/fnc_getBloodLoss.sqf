#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Calculate the total blood loss of a unit.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * Return Value:
 * Total blood loss of unit (litres/second) <NUMBER>
 *
 * Example:
 * [player] call ace_medical_status_fnc_getBloodLoss
 *
 * Public: No
 */

params ["_unit"];

private _woundBleeding = GET_WOUND_BLEEDING(_unit);
if (_woundBleeding == 0) exitWith {0};

// even if heart stops blood will still flow slowly (gravity)
private _bloodLoss = _woundBleeding * ([_patient, EGVAR(circulation,cardiacArrestBleedRate)] call FUNC(getBleedingMultiplier));

private _eventArgs = [_unit, _bloodLoss]; // Pass by reference

[QACEGVAR(medical_status,getBloodLoss), _eventArgs] call CBA_fnc_localEvent;

_eventArgs select 1 // return