#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut, PabstMirror
 * Adds a medication and it's effects
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 * 1: Medication <STRING>
 * 2: Time in system for the adjustment to reach its peak <NUMBER>
 * 3: Duration the adjustment will have an effect <NUMBER>
 * 4: Heart Rate Adjust <NUMBER>
 * 5: Pain Suppress Adjust <NUMBER>
 * 6: Flow Adjust <NUMBER>
 * 7: Administration Route <NUMBER>
    * 0: IM
    * 1: IV
    * 2: PO
    * 3: Inhale
 * 8: Max Effect Time <NUMBER>
 * 9: Respiration Rate Adjust <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "Morphine", 120, 60, -10, 0.8, -10, 0, 60, 0] call ace_medical_status_fnc_addMedicationAdjustment
 *
 * Public: No
 */
params ["_unit", "_medication", "_timeToMaxEffect", "_maxTimeInSystem", "_hrAdjust", "_painAdjust", "_flowAdjust", ["_administrationType", ACM_ROUTE_IM], "_maxEffectTime", "_rrAdjust"];
TRACE_7("addMedicationAdjustment",_unit,_medication,_timeToMaxEffect,_maxTimeInSystem,_hrAdjust,_painAdjust,_flowAdjust);

if (_maxTimeInSystem <= 0) exitWith { WARNING_1("bad value for _maxTimeInSystem - %1",_this); };
_timeToMaxEffect = _timeToMaxEffect max 1;

private _adjustments = _unit getVariable [VAR_MEDICATIONS, []];

_adjustments pushBack [_medication, CBA_missionTime, _timeToMaxEffect, _maxTimeInSystem, _hrAdjust, _painAdjust, _flowAdjust, _administrationType, _maxEffectTime, _rrAdjust];

_unit setVariable [VAR_MEDICATIONS, _adjustments, true];
