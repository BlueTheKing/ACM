#include "..\script_component.hpp"
/*
 * Author: Glowbal
 * Calculate the total blood loss of a unit.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * Return Value:
 * Total blood loss of unit (litres/second) <NUMBER>
 *
 * Example:
 * [player] call ace_medical_status_fnc_getBloodLoss
 *
 * Public: No
 */

params ["_unit"];

private _woundBleeding = GET_WOUND_BLEEDING(_unit);
if (_woundBleeding == 0) exitWith {0};

private _cardiacOutput = [_unit] call ACEFUNC(medical_status,getCardiacOutput);

private _bloodPressureModifier = 1;
private _bloodPressure = GET_BLOOD_PRESSURE(_unit);

_bloodPressure params ["_bpSystolic", "_bpDiastolic"];

if (_bpSystolic > 0 && _bpDiastolic > 0) then {
	private _idealBloodPressure = _unit getVariable [QGVAR(TargetVitals_BloodPressure), [120,80]];

	private _bpSystolicRange = _bpSystolic / (_idealBloodPressure select 0);
	private _bpDiastolicRange = _bpDiastolic / (_idealBloodPressure select 1);

	if ((_bpSystolicRange > 1.2 || _bpSystolicRange < 0.9)) then {
		_bloodPressureModifier = _bpSystolicRange max _bpDiastolicRange;
	};
};

private _coagulationModifier = 1;
private _plateletCount = _unit getVariable [QEGVAR(circulation,Platelet_Count), 3];

if (_plateletCount > 0) then {
	private _plateletCountModifier = ((_plateletCount / 3) - 1) * -0.1;
	_coagulationModifier = _plateletCountModifier + (0.5 max (0.85 * _woundBleeding));
};

// even if heart stops blood will still flow slowly (gravity)
(_woundBleeding * ((_cardiacOutput * _bloodPressureModifier) max GVAR(cardiacArrestBleedRate)) * _coagulationModifier * ACEGVAR(medical,bleedingCoefficient)) // CARIDAC_OUTPUT_MIN (lol)
