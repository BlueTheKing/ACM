#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get current medication concentration.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Medication Classname <STRING>
 * 2: Target Routes <ARRAY<NUMBER>>
 * 3: Target Part Index <NUMBER>
 *
 * Return Value:
 * Concentration <NUMBER>
 *
 * Example:
 * [player, "Paracetamol", [], -1] call ACM_circulation_fnc_getMedicationConcentration;
 *
 * Public: No
 */

params ["_patient", "_medication", ["_route", []], ["_partIndex", -1]];

private _activeMedication = _patient getVariable [QGVAR(ActiveMedication), []];

private _medicationList = [];

private _totalConcentration = 0;

if (_route isEqualTo []) then {
    _route = [ACM_ROUTE_IM,ACM_ROUTE_IV,ACM_ROUTE_PO,ACM_ROUTE_INHALE,ACM_ROUTE_BUCC];
};

{
    _x params ["_entryMedication", "_entryRoute", "_entryPartIndex", "_entryDose", "_entryAdminTime", "_entryAbsorbTime", "_entryMaintainTime", "_entryEliminateTime", "_entryRouteMaximumConcentration"];
    
    if (_entryMedication == _medication && _entryRoute in _route) then {
        if (_partIndex > -1 && {_entryPartIndex != _partIndex}) then {
            continue;
        };

        private _entryConcentration = [_entryDose, _entryAdminTime, _entryAbsorbTime, _entryMaintainTime, _entryEliminateTime] call FUNC(getMedicationConcentration_Single);

        if (_entryRouteMaximumConcentration > 0) then {
            _totalConcentration = _totalConcentration max ((_totalConcentration + _entryConcentration) min _entryRouteMaximumConcentration);
        } else {
            _totalConcentration = _totalConcentration + _entryConcentration;
        };
    };
} forEach _activeMedication;

_totalConcentration;