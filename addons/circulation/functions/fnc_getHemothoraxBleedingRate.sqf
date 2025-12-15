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

// even if heart stops blood will still flow slowly (gravity)
(_hemothoraxBleeding * ([_patient, GVAR(cardiacArrestBleedRate)] call FUNC(getBleedingMultiplier)));