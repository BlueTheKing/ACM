#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set Pressure Cuff placement on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", false] call ACM_circulation_fnc_setPressureCuff;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_state"];

private _hint = LELSTRING(core,Attached);
private _bodyPartHint = ACELLSTRING(Medical_GUI,LeftArm);

if (_bodyPart == "rightarm") then {
    _bodyPartHint = ACELLSTRING(Medical_GUI,RightArm);
};

if (_state && (([_patient, _bodyPart, 3] call FUNC(hasAED)) || [_patient, _bodyPart] call FUNC(hasPressureCuff))) exitWith {
    [(format [LLSTRING(PressureCuff_Already), toLower ([_bodyPart] call EFUNC(core,getBodyPartString))]), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

if !(_state) then {
    _hint = LELSTRING(core,Removed);
};

[(format ["%1 %2", _hint, LLSTRING(PressureCuff)]), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "activity", "%1 %2 %3 (%4)", [[_medic, false, true] call ACEFUNC(common,getName), (toLower _hint), LLSTRING(PressureCuff), _bodyPartHint]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(setPressureCuffLocal), [_medic, _patient, _bodyPart, _state], _patient] call CBA_fnc_targetEvent;