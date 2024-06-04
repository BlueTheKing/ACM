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

private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);

private _coagulationModifier = 1;
private _plateletCount = _unit getVariable [QEGVAR(circulation,Platelet_Count), 3];

if (_plateletCount > 0.1) then {
    private _plateletCountModifier = ((_plateletCount / 3) - 1) * -0.1;
    _coagulationModifier = _plateletCountModifier + (0.6 max (0.95 * _woundBleeding));
};

// even if heart stops blood will still flow slowly (gravity)
private _bloodLoss = (_woundBleeding * (_cardiacOutput max EGVAR(circulation,cardiacArrestBleedRate)) * _coagulationModifier * ACEGVAR(medical,bleedingCoefficient));

private _eventArgs = [_unit, _bloodLoss]; // Pass by reference

[QACEGVAR(medical_status,getBloodLoss), _eventArgs] call CBA_fnc_localEvent;

_eventArgs select 1 // return