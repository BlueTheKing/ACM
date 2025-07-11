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

private _morphine = 0;
private _morphineIV = 0;
private _fentanyl  = 0;
private _fentanylIV = 0;
private _ketamine  = 0;
private _ketamineIV = 0;
private _amiodaroneIV = 0;
private _lidocaine = 0;
private _lidocaineIV = 0;

private _ondansetron = 0;
private _ondansetronIV = 0;

//ace_medical_status_fnc_getMedicationCount
{
    _x params ["_medication", "_timeAdded", "_timeTillMaxEffect", "_maxTimeInSystem", "", "", "", "_administrationType", "_maxEffectTime", "", "", "", "_concentration"];

    if !(_medication in ["Morphine","Morphine_IV","Fentanyl","Fentanyl_IV","Ketamine","Ketamine_IV","Amiodarone_IV","Lidocaine","Lidocaine_IV","Ondansetron","Ondansetron_IV"]) then {
        continue;
    };

    private _timeInSystem = CBA_missionTime - _timeAdded;

    private _getEffect = [_administrationType, _timeInSystem, _timeTillMaxEffect, _maxTimeInSystem, _maxEffectTime, _concentration] call FUNC(getMedicationEffect);

    switch (_medication) do {
        case "Morphine": {
            _morphine = _morphine + _getEffect;
        };
        case "Morphine_IV": {
            _morphineIV = _morphineIV + _getEffect;
        };
        case "Fentanyl": {
            _fentanyl = _fentanyl + _getEffect;
        };
        case "Fentanyl_IV": {
            _fentanylIV = _fentanylIV + _getEffect;
        };
        case "Ketamine": {
            _ketamine = _ketamine + _getEffect;
        };
        case "Ketamine_IV": {
            _ketamineIV = _ketamineIV + _getEffect;
        };
        case "Amiodarone_IV": {
            _amiodaroneIV = _amiodaroneIV + _getEffect;
        };
        case "Lidocaine": {
            _lidocaine = _lidocaine + _getEffect;
        };
        case "Lidocaine_IV": {
            _lidocaineIV = _lidocaineIV + _getEffect;
        };
        case "Ondansetron": {
            _ondansetron = _ondansetron + _getEffect;
        };
        case "Ondansetron_IV": {
            _ondansetronIV = _ondansetronIV + _getEffect;
        };
    };
} forEach (_patient getVariable [VAR_MEDICATIONS, []]);

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

private _ondansetronSuppression = [(_ondansetronIV + _ondansetron), ((_ondansetronIV + _ondansetron) * 0.5)] select ((([_patient, "Ondansetron_IV", false] call ACEFUNC(medical_status,getMedicationCount)) + (([_patient, "Ondansetron", false] call ACEFUNC(medical_status,getMedicationCount)) * 0.5)) > 2);

private _medicationNausea = 1.2 min ((1 min (_morphineIV + _morphine)) + (1 min (_fentanylIV + _fentanyl)) + (1 min (_ketamineIV + _ketamine)) + (1 min (_lidocaineIV + _lidocaine)) + _amiodaroneIV);

_medicationNausea - _ondansetronSuppression;