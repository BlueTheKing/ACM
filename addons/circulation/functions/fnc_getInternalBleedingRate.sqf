#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get internal bleeding rate affected by cardiac output and coagulation
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Internal bleeding rate of unit <NUMBER>
 *
 * Example:
 * [player] call ACM_circulation_fnc_getInternalBleedingRate;
 *
 * Public: No
 */

params ["_unit"];

private _internalBleeding = GET_INTERNAL_BLEEDING(_unit);
if (_internalBleeding == 0) exitWith {0};

private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);

private _coagulationModifier = 1;
private _plateletCount = _unit getVariable [QGVAR(Platelet_Count), 3];
private _TXACount = ([_unit, "TXA_IV", false] call ACEFUNC(medical_status,getMedicationCount)) min 1.4;

if (_plateletCount > 0 || _TXACount > 0.1) then {
    private _plateletCountModifier = ((_plateletCount / 3) - 1) * -0.1;
    _coagulationModifier = _plateletCountModifier + (0.5 max (0.75 * _internalBleeding)) - (0.35 * _TXACount);
};

// even if heart stops blood will still flow slowly (gravity)
(_internalBleeding * (_cardiacOutput max (GVAR(cardiacArrestBleedRate) / 2)) * _coagulationModifier * ACEGVAR(medical,bleedingCoefficient));