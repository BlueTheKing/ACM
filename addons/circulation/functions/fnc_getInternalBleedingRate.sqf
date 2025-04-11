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
private _resistance = _unit getVariable [VAR_PERIPH_RES, DEFAULT_PERIPH_RES];

// even if heart stops blood will still flow slowly (gravity)
(_internalBleeding * (_cardiacOutput max (GVAR(cardiacArrestBleedRate) / 2)) * (DEFAULT_PERIPH_RES / _resistance) * ACEGVAR(medical,bleedingCoefficient));