#include "..\script_component.hpp"
/*
 * Author: Blue
 * Administer medication. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Bodypart Index <NUMBER>
 * 2: Mediation Classname <STRING>
 * 3: Dose <NUMBER>
 * 4: Route <NUMBER>
 * 5: Is IV? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 0, "Paracetamol", 500, ACM_ROUTE_PO] call ACM_circulation_fnc_administerMedicationLocal;
 *
 * Public: No
 */

params ["_patient", "_partIndex", "_medication", "_dose", "_route"];

private _activeMedication = _patient getVariable [QGVAR(ActiveMedication), []];

private _config = configFile >> "ACM_Medication" >> "Medication" >> _medication;

private _configRoute = _config >> GET_ROUTE_CONFIG(_route);

if !(isClass _configRoute) exitWith {};

private _availability = 1;

if (isNumber (_configRoute >> "availability")) then {
    _availability = getNumber (_configRoute >> "availability");
};

_dose = _dose * _availability;

private _eliminateTime = getNumber (_config >> "eliminatePhase");

private _absorptionTime = getNumber (_configRoute >> "absorbPhase");
private _maintainTime = getNumber (_configRoute >> "maintainPhase");

private _routeMaximumConcentration = 0;

if (isNumber (_configRoute >> "maximumConcentration")) then {
    _routeMaximumConcentration = getNumber (_configRoute >> "maximumConcentration");
};

if (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex) && (_route == ACM_ROUTE_IM || (_route == ACM_ROUTE_IV && (!([_patient, (ALL_BODY_PARTS select _partIndex)] call FUNC(hasIO)) || _partIndex > 3)))) exitWith {
    private _blockedMedication = _patient getVariable [QGVAR(BlockedMedication), []];

    _blockedMedication pushBack [_medication, _route, _partIndex, _dose];

    _patient setVariable [QGVAR(BlockedMedication), _blockedMedication, true];
};

_activeMedication pushBack [_medication, _route, _partIndex, _dose, CBA_missionTime, _absorptionTime, _maintainTime, _eliminateTime, _routeMaximumConcentration];

_patient setVariable [QGVAR(ActiveMedication), _activeMedication, true];

private _effectFunction = MEDICATION_EFFECT_FUNCTION(_medication);

if (typeName _effectFunction isEqualTo "CODE") then {
    [_patient] call _effectFunction;
};