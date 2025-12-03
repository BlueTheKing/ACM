#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return cardiac effects of medication.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Medication effect <HASHMAP<NUMBER>>
 *
 * Example:
 * [cursorTarget] call ACM_circulation_fnc_getCardiacMedicationEffects;
 *
 * Public: No
 */

params ["_patient"];

private _weight = GET_BODYWEIGHT(_patient);

private _morphine = ([_patient, "Morphine", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration)) / (0.1 * _weight);
private _morphineIV = ([_patient, "Morphine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / (0.1 * _weight);
private _fentanyl = ([_patient, "Fentanyl", [ACM_ROUTE_IM]] call FUNC(getMedicationConcentration)) / (1 * _weight); // mcg
private _fentanylIV = ([_patient, "Fentanyl", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / (1 * _weight); // mcg
private _epinephrineIV = ([_patient, "Epinephrine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / 1;
private _amiodaroneIV = ([_patient, "Amiodarone", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / 300;
private _lidocaineIV = ([_patient, "Lidocaine", [ACM_ROUTE_IV]] call FUNC(getMedicationConcentration)) / _weight;

_morphine = (_morphine * 0.3) min 0.5;
_morphineIV = (_morphineIV * 0.6) min 0.8;
_fentanyl = (_fentanyl * 0.3) min 0.5;
_fentanylIV = (_fentanylIV * 0.6) min 0.8;
_epinephrineIV = (_epinephrineIV * 1.2) min 1;
_amiodaroneIV = _amiodaroneIV min 1;
_lidocaineIV = _lidocaineIV min 1;

(createHashMapFromArray [["morphine", (_morphine max _morphineIV)], ["fentanyl", (_fentanyl max _fentanylIV)], ["epinephrine", _epinephrineIV], ["amiodarone",_amiodaroneIV], ["lidocaine",_lidocaineIV]]);