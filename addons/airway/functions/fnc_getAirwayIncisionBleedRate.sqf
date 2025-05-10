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

private _cardiacOutput = [_patient] call ACEFUNC(medical_status,getCardiacOutput);
private _resistance = _patient getVariable [VAR_PERIPH_RES, DEFAULT_PERIPH_RES];

// even if heart stops blood will still flow slowly (gravity)
(_incisionBleeding * (_cardiacOutput max EGVAR(circulation,cardiacArrestBleedRate)) * (DEFAULT_PERIPH_RES / _resistance) * ACEGVAR(medical,bleedingCoefficient));