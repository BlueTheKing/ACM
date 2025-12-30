#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle administering syringe medication.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Medication Classname <STRING>
 * 4: Syringe Size <NUMBER>
 * 5: IV? <BOOL>
 * 6: Return Syringe? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "RightArm", "Morphine", 10, true, true] call ACM_circulation_fnc_Syringe_Inject;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_classname", ["_size", 10], ["_iv", true], ["_returnSyringe", true]];

if (_iv && !([_patient, _bodyPart, 0] call FUNC(hasIV)) && !([_patient, _bodyPart, 0] call FUNC(hasIO))) exitWith {
    [[LSTRING(Syringe_PushFailed), ([_bodyPart, false] call EFUNC(core,getBodyPartString))], 2, _medic, 13] call ACEFUNC(common,displayTextStructured);
};

private _itemClassname = "";
private _administrationString = LSTRING(Intramuscular_Short);
private _actionHintString = LSTRING(Syringe_Injected);
private _actionLogString = LSTRING(Syringe_%1_Injected);
private _medicationName = format ["STR_ACM_Circulation_Medication_%1", _classname];
private _medicationClassname = _classname;

if (_iv) then {
    _administrationString = LSTRING(Intravenous_Short);
    _actionHintString = LSTRING(Syringe_Pushed);
    _actionLogString = LSTRING(Syringe_%1_Pushed);
};

_itemClassname = format ["ACM_Syringe_%1_%2", _size, _classname];

private _doseVolume = 0;

{
    private _targetItems = [];
    _targetItems append ((magazinesAmmoCargo _x) select {(_x select 0) == _itemClassname});

    if (count _targetItems < 1) then {
        continue;
    };

    _targetItems sort false;

    private _count = ((_targetItems select 0) select 1);
    _doseVolume = _count;

    _x addMagazineAmmoCargo [_itemClassname, -1, _count];
    break;
} forEach [uniformContainer _medic, vestContainer _medic, backpackContainer _medic];

if (_doseVolume < 1) exitWith {};

private _vialDose = getNumber (configFile >> "ACM_Medication" >> "Medication" >> _classname >> "Vial" >> "dose");
private _vialVolume = getNumber (configFile >> "ACM_Medication" >> "Medication" >> _classname >> "Vial" >> "volume");

private _vialConcentration = _vialDose / _vialVolume;

private _stringDose = _vialConcentration * (_doseVolume / 100);

private _microDose = [false, true] select (getNumber (configFile >> "ACM_Medication" >> "Medication" >> _classname >> "isMicroDose"));

private _doseMeasurement = ["mg", "mcg"] select _microDose;

if !(_microDose) then {
    if (_stringDose < 1) then {
        _stringDose = round (_stringDose * 10);
        _stringDose = (_stringDose / 10);
    } else {
        _stringDose = round(_stringDose);
        if (_stringDose >= 1000) then {
            _stringDose = _stringDose / 1000;
            _doseMeasurement = "g";
        };
    };
};

[_patient, format ["%1 %2 (%3%4)", localize _medicationName, localize _administrationString, _stringDose, _doseMeasurement]] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", "%1 %2 %3 (%4%5)", [[_actionLogString, ([_medic, false, true] call ACEFUNC(common,getName))], _medicationName, _administrationString, _stringDose, _doseMeasurement]] call ACEFUNC(medical_treatment,addToLog);
[["%1 %2 %3", _actionHintString, _administrationString, _medicationName], 1.5, _medic] call ACEFUNC(common,displayTextStructured);

if (_returnSyringe) then {
    [_medic, (format ["ACM_Syringe_%1", _size])] call ACEFUNC(common,addToInventory);
};

[QGVAR(administerMedicationLocal), [_patient, GET_BODYPART_INDEX(_bodyPart), _medicationClassname, (_vialConcentration * (_doseVolume / 100)), ([ACM_ROUTE_IM, ACM_ROUTE_IV] select _iv)], _patient] call CBA_fnc_targetEvent;

if (!_iv && (([_patient, "Lidocaine", [ACM_ROUTE_IM], GET_BODYPART_INDEX(_bodyPart)] call FUNC(getMedicationConcentration)) < 0.5)) then {
    [_patient, (linearConversion [1, 10, (_doseVolume / 100), 0.1, 0.8])] call ACEFUNC(medical,adjustPainLevel);
    [_patient, "hit"] call ACEFUNC(medical_feedback,playInjuredSound);
};

[QEGVAR(core,openMedicalMenu), _patient] call CBA_fnc_localEvent;