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
    [(format [LLSTRING(Syringe_PushFailed), toLower ([_bodyPart] call EFUNC(core,getBodyPartString))]), 2, _medic, 13] call ACEFUNC(common,displayTextStructured);
};

private _itemClassname = "";
private _administrationString = LLSTRING(Intramuscular_Short);
private _actionString = LLSTRING(Syringe_Injected);
private _medicationClassname = _classname;

if (_iv) then {
    _medicationClassname = format ["%1_IV", _classname];
    _administrationString = LLSTRING(Intravenous_Short);
    _actionString = LLSTRING(Syringe_Pushed);
};

_itemClassname = format ["ACM_Syringe_%1_%2", _size, _classname];

private _dose = 0;

{
    private _targetItems = [];
    _targetItems append ((magazinesAmmoCargo _x) select {(_x select 0) == _itemClassname});

    if (count _targetItems < 1) then {
        continue;
    };

    _targetItems sort false;

    private _count = ((_targetItems select 0) select 1);
    _dose = _count;

    _x addMagazineAmmoCargo [_itemClassname, -1, _count];
    break;
} forEach [uniformContainer _medic, vestContainer _medic, backpackContainer _medic];

if (_dose < 1) exitWith {};

private _medicationConcentration = getNumber (configFile >> "ACM_Medication" >> "Concentration" >> _classname >> "concentration");

private _stringDose = (_dose / 100) * _medicationConcentration;

if (_stringDose < 1) then {
    _stringDose = round (_stringDose * 10);
    _stringDose = (_stringDose / 10);
} else {
    _stringDose = round(_stringDose);
};

[_patient, format ["%1 %2 (%3mg)", _classname, _administrationString, _stringDose]] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", "%1 %2 %3 %4 (%5mg)", [[_medic, false, true] call ACEFUNC(common,getName), (toLower _actionString), _classname, _administrationString, _stringDose]] call ACEFUNC(medical_treatment,addToLog);
[(format ["%1 %2 %3", _actionString, _administrationString, _classname]), 1.5, _medic] call ACEFUNC(common,displayTextStructured);

if (_returnSyringe) then {
    [_medic, (format ["ACM_Syringe_%1", _size])] call ACEFUNC(common,addToInventory);
};

private _concentrationDose = _medicationConcentration * (_dose / 100);

[QACEGVAR(medical_treatment,medicationLocal), [_patient, _bodyPart, _medicationClassname, _concentrationDose], _patient] call CBA_fnc_targetEvent;