#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get time required to stitch surgical airway incision.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Use Suture <BOOL>
 *
 * Return Value:
 * Stitch Time <NUMBER>
 *
 * Example:
 * [player, cursorTarget, false] call ACM_airway_fnc_getStitchAirwayIncisionTime;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_useSuture", false]];

private _incisionCount = _patient getVariable [QGVAR(SurgicalAirway_IncisionCount), 0];
private _multiplier = [5, EGVAR(core,treatmentTimeSutureStitch)] select _useSuture;

_incisionCount * _multiplier;