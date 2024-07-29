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

private _hintState = LELSTRING(core,Common_Inserted);
private _hintType = LLSTRING(IV_16g);

private _exit = false;
private _accessSiteHint = "";
private _givePain = 0;

switch (_type) do {
    case ACM_IV_14G: {
        _hintType = LLSTRING(IV_14g);
    };
    case ACM_IO_FAST1_M: {
        _hintType = LLSTRING(IO_FAST1);
        _givePain = 0.5;
    };
    case ACM_IO_EZ_M: {
        _hintType = LLSTRING(IO_EZ);
        _givePain = 0.25;
    };
    default {};
};

if (_iv) then {
    _accessSiteHint = [LLSTRING(IV_Upper), LLSTRING(IV_Middle), LLSTRING(IV_Lower)] select _accessSite;

    if (_state && [_patient, _bodyPart, 0, _accessSite] call FUNC(hasIV)) exitWith {
        _exit = true;
        [(format [LLSTRING(IV_Already), toLower ([_bodyPart] call EFUNC(core,getBodyPartString)), _accessSiteHint]), 2, _medic] call ACEFUNC(common,displayTextStructured);
    };
} else {
    if (_state && [_patient, _bodyPart] call FUNC(hasIO)) exitWith {
        _exit = true;
        [(format [LLSTRING(IO_Already), toLower ([_bodyPart] call EFUNC(core,getBodyPartString))]), 2, _medic] call ACEFUNC(common,displayTextStructured);
    };
};

if (_exit) exitWith {};

private _setState = _type;

if (_state) then {
    if !(_iv) then {
        [_patient, _givePain] call ACEFUNC(medical,adjustPainLevel);
    };
} else {
    _hintState = LELSTRING(core,Common_Removed);
    _setState = 0;
};

if (_iv) then {
    [_patient, "activity", "%1 %2 %3 (%4)", [[_medic, false, true] call ACEFUNC(common,getName), (toLower _hintState), _hintType, _accessSiteHint]] call ACEFUNC(medical_treatment,addToLog);
} else {
    [_patient, "activity", "%1 %2 %3", [[_medic, false, true] call ACEFUNC(common,getName), (toLower _hintState), _hintType]] call ACEFUNC(medical_treatment,addToLog);
};

[QGVAR(setIVLocal), [_medic, _patient, _bodyPart, _setState, _iv, _accessSite], _patient] call CBA_fnc_targetEvent;