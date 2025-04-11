#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return if patient medication is outside of safe range
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Has Overdose? <BOOL>
 *
 * Example:
 * [player] call ACM_circulation_fnc_isOverdosed;
 *
 * Public: No
 */

params ["_patient"];

private _medicationOverdose = false;

{
    if (([_patient, _x, false] call ACEFUNC(medical_status,getMedicationCount)) > 0.1) exitWith {
        _medicationOverdose = true;
        break;
    };
} forEach ["Overdose_Amiodarone","Overdose_Ketamine","Overdose_Lidocaine","Overdose_Opioid","Overdose_Penthrox"];

if (_medicationOverdose) exitWith {true};

private _return = false;
private _lastHeartRate = _patient getVariable [QGVAR(HeartRate_Last), 0];

private _list = [];

if (_lastHeartRate < 50) then {
    _list = ["Amiodarone_IV","Morphine","Morphine_IV","Fentanyl","Fentanyl_IV","Fentanyl_BUC","Midazolam","Lidocaine_IV","Ondansetron","Ondansetron_IV","Adenosine_IV","Esmolol_IV"];
};

if (_lastHeartRate > ACM_TARGETVITALS_MAXHR(_patient)) then {
    _list = ["Epinephrine","Epinephrine_IV","Atropine","Atropine_IV","Dimercaprol"];
};

{
    private _bodyConcentration = [_patient, _x, false] call ACEFUNC(medical_status,getMedicationCount);
    
    if (_bodyConcentration == 0) then {
        continue;
    };

    private _medicationEntryConfig = configFile >> "ACM_Medication" >> "Medications" >> _x;
    private _unstableDose = getNumber (_medicationEntryConfig >> "unstableDose");

    if (_unstableDose == 0) then {
        continue;
    };

    private _maxEffectDose = getNumber (_medicationEntryConfig >> "maxEffectDose");
    private _weightEffect = getNumber (_medicationEntryConfig >> "weightEffect");

    if (_weightEffect > 0) then {
        private _patientWeight = GET_BODYWEIGHT(_patient);

        _bodyConcentration = _bodyConcentration * ((_maxEffectDose / IDEAL_BODYWEIGHT) * _patientWeight);
    } else {
        _bodyConcentration = _bodyConcentration * _maxEffectDose;
    };

    if (_bodyConcentration > _unstableDose) then {
        _return = true;
        break;
    };
} forEach _list;

_return;