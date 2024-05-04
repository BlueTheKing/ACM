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

private _internalBleeding = GET_INTERNAL_BLEEDING(_unit);
if (_internalBleeding == 0) exitWith {0};

private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);

private _coagulationModifier = 1;
private _plateletCount = _unit getVariable [QGVAR(Platelet_Count), 3];

if (_plateletCount > 0) then {
    private _plateletCountModifier = ((_plateletCount / 3) - 1) * -0.1;
    _coagulationModifier = _plateletCountModifier + (0.5 max (0.75 * _internalBleeding));
};

// even if heart stops blood will still flow slowly (gravity)
(_internalBleeding * (_cardiacOutput  max EGVAR(circulation,cardiacArrestBleedRate)) * _coagulationModifier * ACEGVAR(medical,bleedingCoefficient));