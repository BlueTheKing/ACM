#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get open surgical airway incision bleeding rate affected by cardiac output and coagulation.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Bleed Rate <NUMBER>
 *
 * Example:
 * [player] call ACM_airway_fnc_getAirwayIncisionBleedRate;
 *
 * Public: No
 */

params ["_patient"];

private _incisionBleeding = (_patient getVariable [QGVAR(SurgicalAirway_IncisionCount), 0]) * (0.02 * (_patient getVariable [QGVAR(SurgicalAirway_IncisionSeverity), 0]));
if (_incisionBleeding == 0 || _patient getVariable [QGVAR(SurgicalAirway_IncisionStitched), false]) exitWith {0};

// even if heart stops blood will still flow slowly (gravity)
(_incisionBleeding * ([_patient, EGVAR(circulation,cardiacArrestBleedRate)] call EFUNC(circulation,getBleedingMultiplier)));