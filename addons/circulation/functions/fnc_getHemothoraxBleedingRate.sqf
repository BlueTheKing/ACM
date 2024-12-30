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

private _hemothoraxBleeding = (_unit getVariable [QEGVAR(breathing,Hemothorax_State), 0]) * 0.006;
if (_hemothoraxBleeding == 0) exitWith {0};

private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);
private _resistance = _unit getVariable [VAR_PERIPH_RES, DEFAULT_PERIPH_RES];

private _TXAEffect = 1 - (0.1 * (([_unit, "TXA_IV", false] call ACEFUNC(medical_status,getMedicationCount)) min 2));

// even if heart stops blood will still flow slowly (gravity)
(_hemothoraxBleeding * _TXAEffect * (_cardiacOutput max GVAR(cardiacArrestBleedRate)) * (DEFAULT_PERIPH_RES / _resistance) * ACEGVAR(medical,bleedingCoefficient));