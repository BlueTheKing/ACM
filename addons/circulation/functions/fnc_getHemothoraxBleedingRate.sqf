#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get hemothorax bleeding rate affected by cardiac output and coagulation
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Hemothorax bleeding rate of unit <NUMBER>
 *
 * Example:
 * [player] call ACM_circulation_fnc_getHemothoraxBleedingRate;
 *
 * Public: No
 */

params ["_unit"];

private _hemothoraxBleeding = (_unit getVariable [QEGVAR(breathing,Hemothorax_State), 0]) * 0.02;
if (_hemothoraxBleeding == 0) exitWith {0};

private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);

private _coagulationModifier = 1;
private _plateletCount = _unit getVariable [QGVAR(Platelet_Count), 3];

if (_plateletCount > 0) then {
    private _plateletCountModifier = ((_plateletCount / 3) - 1) * -0.1;
    _coagulationModifier = _plateletCountModifier + (0.5 max (0.75 * _hemothoraxBleeding));
};

// even if heart stops blood will still flow slowly (gravity)
(_hemothoraxBleeding * (_cardiacOutput max GVAR(cardiacArrestBleedRate)) * _coagulationModifier * ACEGVAR(medical,bleedingCoefficient));