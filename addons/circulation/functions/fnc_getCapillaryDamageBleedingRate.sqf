#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get damaged capillary bleeding rate affected by cardiac output
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Capillary bleeding rate of unit <NUMBER>
 *
 * Example:
 * [player] call ACM_circulation_fnc_getCapillaryDamageBleedingRate;
 *
 * Public: No
 */

params ["_patient"];

private _capillaryBleeding = GET_CAPILLARY_DAMAGE(_patient) * 0.0004;
if (_capillaryBleeding == 0) exitWith {0};

// even if heart stops blood will still flow slowly (gravity)
(_capillaryBleeding * ([_patient, GVAR(cardiacArrestBleedRate)] call FUNC(getBleedingMultiplier)));