#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return nausea caused by medications.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Medication Nausea <NUMBER>
 *
 * Example:
 * [cursorTarget] call ACM_circulation_fnc_getNauseaMedicationEffects;
 *
 * Public: No
 */

params ["_patient"];

private _weight = GET_BODYWEIGHT(_patient);

private _morphine = ([_patient, "Morphine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration)) / (0.1 * _weight);
private _morphineIV = ([_patient, "Morphine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / (0.1 * _weight);
private _fentanyl = ([_patient, "Fentanyl", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration)) / (1 * _weight); // mcg
private _fentanylIV = ([_patient, "Fentanyl", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / (1 * _weight); // mcg
private _ketamine = ([_patient, "Ketamine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration)) * (1.5 * _weight);
private _ketamineIV = ([_patient, "Ketamine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) * (1.5 * _weight);
private _amiodaroneIV = ([_patient, "Amiodarone", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / 450;
private _lidocaine = ([_patient, "Lidocaine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration)) / 70;
private _lidocaineIV = ([_patient, "Lidocaine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / (2 * _weight);

private _ondansetron = ([_patient, "Ondansetron", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration)) / 4;
private _ondansetronIV = ([_patient, "Ondansetron", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / 4;

_morphineIV = (linearConversion [0.3, 1, _morphineIV, 0, 1]) max 0;
_morphine = (linearConversion [0.3, 1, (_morphine * 0.5), 0, 1]) max 0;

_fentanylIV = (linearConversion [0.5, 1, _fentanylIV, 0, 1]) max 0;
_fentanyl = (linearConversion [0.5, 1, (_fentanyl * 0.5), 0, 1]) max 0;

_ketamineIV = (linearConversion [0.3, 1, _ketamineIV, 0, 1]) max 0;
_ketamine = (linearConversion [0.3, 1, (_ketamine * 0.5), 0, 1]) max 0;

_lidocaineIV = (linearConversion [0.6, 1, _lidocaineIV, 0, 1]) max 0;
_lidocaine = (linearConversion [0.4, 1, (_lidocaine * 0.5), 0, 1]) max 0;

_amiodaroneIV = (linearConversion [0.5, 1, _amiodaroneIV, 0, 1]) max 0;

_ondansetronIV = (linearConversion [0.5, 1, _ondansetronIV, 0, 0.9, true]) max 0;
_ondansetron = (linearConversion [0.5, 1, (_ondansetron * 0.6), 0, 0.5, true]) max 0;

private _ondansetronSuppression = [(_ondansetronIV + _ondansetron), ((_ondansetronIV + _ondansetron) * 0.5)] select (((_ondansetronIV + (_ondansetron * 0.5))) > 2);

private _medicationNausea = 1.2 min ((1 min (_morphineIV + _morphine)) + (1 min (_fentanylIV + _fentanyl)) + (1 min (_ketamineIV + _ketamine)) + (1 min (_lidocaineIV + _lidocaine)) + _amiodaroneIV);

_medicationNausea - _ondansetronSuppression;