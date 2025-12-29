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

private _hintArray = ["%1 %2"];
private _hintLogArray = [[_medic, false, true] call ACEFUNC(common,getName)];
private _bodyPartHint = [ACELSTRING(Medical_GUI,LeftArm), ACELSTRING(Medical_GUI,RightArm)] select (_bodyPart == "rightarm");

if (_state && (([_patient, _bodyPart, 3] call FUNC(hasAED)) || [_patient, _bodyPart] call FUNC(hasPressureCuff) || [_patient, _bodyPart, 0, 0] call FUNC(hasIV))) exitWith {
    _hintArray = [([LSTRING(PressureCuff_Already), _bodyPartHint]),([LSTRING(PressureCuff_Blocked_IV)])] select ([_patient, _bodyPart, 0, 0] call FUNC(hasIV));

    [_hintArray, 2, _medic] call ACEFUNC(common,displayTextStructured);
    [_medic, "ACM_PressureCuff"] call ACEFUNC(common,addToInventory);
};

if (_state) then {
    _hintArray pushBack ELSTRING(core,Common_Attached);
    _hintLogArray pushBack ELSTRING(core,Common_Attached);
} else {
    _hintArray pushBack ELSTRING(core,Common_Removed);
    _hintLogArray pushBack ELSTRING(core,Common_Removed);
};

_hintArray pushBack LSTRING(PressureCuff);
_hintLogArray append [LSTRING(PressureCuff), _bodyPartHint];

[_hintArray, 1.5, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "activity", "%1 %2 %3 (%4)", _hintLogArray] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(setPressureCuffLocal), [_medic, _patient, _bodyPart, _state], _patient] call CBA_fnc_targetEvent;