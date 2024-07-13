#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set IV placement on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Type <NUMBER>
 * 4: State <BOOL>
 * 5: Is IV? <BOOL>
 * 6: Access Site <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 1, true, true, 0] call ACM_circulation_fnc_setIV;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type", "_state", ["_iv", true], ["_accessSite", -1]];

private _hintState = "inserted";
private _hintType = "16g IV";

private _accessSiteHint = "";

switch (_type) do {
    case ACM_IV_14G: {
        _hintType = "14g IV";
    };
    case ACM_IO_FAST1: {
        _hintType = "FAST1 IO";
    };
    case ACM_IO_EZ: {
        _hintType = "EZ-IO";
    };
    default {};
};

if (_iv) then {
    _accessSiteHint = ["Upper","Middle","Lower"] select _accessSite;

    if (_state && [_patient, _bodyPart, _accessSite] call FUNC(hasIV)) exitWith {
        [(format ["Patient already has IV in %1 (%2)", toLower ([_bodyPart] call EFUNC(core,getBodyPartString)), _accessSiteHint]), 2, _medic] call ACEFUNC(common,displayTextStructured);
    };
} else {
    if (_state && [_patient, _bodyPart] call FUNC(hasIO)) exitWith {
        [(format ["Patient already has IO in %1", toLower ([_bodyPart] call EFUNC(core,getBodyPartString))]), 2, _medic] call ACEFUNC(common,displayTextStructured);
    };
};

private _setState = _type;

if (_state) then {
    if !(_iv) then {
        [_patient, 0.4] call ACEFUNC(medical,adjustPainLevel);
    };
} else {
    _hintState = "removed";
    _setState = 0;
};

if (_iv) then {
    [_patient, "activity", "%1 %2 %3 (%4)", [[_medic, false, true] call ACEFUNC(common,getName), _hintState, _hintType, _accessSiteHint]] call ACEFUNC(medical_treatment,addToLog);
} else {
    [_patient, "activity", "%1 %2 %3", [[_medic, false, true] call ACEFUNC(common,getName), _hintState, _hintType]] call ACEFUNC(medical_treatment,addToLog);
};

[QGVAR(setIVLocal), [_medic, _patient, _bodyPart, _setState, _iv, _accessSite], _patient] call CBA_fnc_targetEvent;