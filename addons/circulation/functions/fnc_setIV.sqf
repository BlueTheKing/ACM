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
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 1, true] call ACM_circulation_fnc_setIV;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type", "_state"];

private _hintState = "inserted";
private _hintType = "16g IV";
private _insertPain = 0;

switch (_type) do {
    case ACM_IV_14G_M: {_hintType = "14g IV";};
    case ACM_IO_FAST1_M: {
        _hintType = "IO";
        _insertPain = 0.4;
    };
    default {};
};

if (_state && [_patient, _bodyPart, _type] call FUNC(hasIV)) exitWith {
    [(format ["Patient already has %1 in %2", _hintType, toLower ([_bodyPart] call EFUNC(core,getBodyPartString))]), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

private _setState = _type;

if (_state) then {
    if (_insertPain > 0) then {
        [_patient, _insertPain] call ACEFUNC(medical_status,adjustPainLevel);
    };
} else {
    _hintState = "removed";
    _setState = 0;
};

[_patient, "activity", "%1 %2 %3", [[_medic, false, true] call ACEFUNC(common,getName), _hintState, _hintType]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(setIVLocal), [_medic, _patient, _bodyPart, _setState], _patient] call CBA_fnc_targetEvent;