#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Calculate the blood pressure of a unit.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 * 1: Bleeding Rate of Unit <NUMBER>
 *
 * Return Value:
 * 0: BloodPressure Low <NUMBER>
 * 1: BloodPressure High <NUMBER>
 *
 * Example:
 * [player] call ace_medical_status_fnc_getBloodPressure
 *
 * Public: No
 */

// Value is taken because with cardic output and resistance at default values, it will put blood pressure High at 120.
#define MODIFIER_BP_HIGH    9.4736842

// Value is taken because with cardic output and resistance at default values, it will put blood pressure Low at 80.
#define MODIFIER_BP_LOW     6.3157894

params ["_unit"];

private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);
private _resistance = _unit getVariable [VAR_PERIPH_RES, DEFAULT_PERIPH_RES];
private _bloodPressure = _cardiacOutput * _resistance;

private _tensionEffect = 0;

private _vasoconstrictionMultiplier = (1 - GET_WOUND_BLEEDING(_unit) * 0.1); // Simulate constriction of veins in reaction to bleeding

if (_unit getVariable [QEGVAR(breathing,Pneumothorax_State), 0] > 0) then {
    _tensionEffect = (_unit getVariable [QEGVAR(breathing,Pneumothorax_State), 0]) * 8;
};

if (_unit getVariable [QEGVAR(breathing,TensionPneumothorax_State), false]) then {
    _tensionEffect = 35;
};

[(round(((_bloodPressure * MODIFIER_BP_LOW) - _tensionEffect) * _vasoconstrictionMultiplier)) max 0, (round(((_bloodPressure * MODIFIER_BP_HIGH) - _tensionEffect) * _vasoconstrictionMultiplier)) max 0]