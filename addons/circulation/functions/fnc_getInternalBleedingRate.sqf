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

// even if heart stops blood will still flow slowly (gravity)
(_internalBleeding * ([_patient, (GVAR(cardiacArrestBleedRate) / 2)] call FUNC(getBleedingMultiplier)));