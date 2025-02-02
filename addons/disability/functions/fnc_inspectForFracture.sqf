#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform limb inspection for fracture.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_inspectForFracture;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

private _hint = "";
private _hintLog = "";
private _hintHeight = 2;

private _bodyPartString = [_bodyPart] call EFUNC(core,getBodyPartString);

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

private _fractureState = (_patient getVariable [QGVAR(Fracture_State), [0,0,0,0,0,0]]) select _partIndex;
private _bodyPartDamage = ((_patient getVariable [QACEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]]) select _partIndex);

switch (true) do {
    case ((GET_SPLINTS(_patient) select _partIndex) > 0): {
        _hint = LLSTRING(InspectFracture_SplintApplied);
        _hintLog = LLSTRING(InspectFracture_SplintApplied_Short);
    };
    case (_fractureState == ACM_FRACTURE_COMPLEX): {
        _hint = LLSTRING(InspectFracture_SignificantSwelling);
        _hintLog = LLSTRING(InspectFracture_SignificantSwelling_Short);
    };
    case (_fractureState == ACM_FRACTURE_SEVERE): {
        _hint = LLSTRING(InspectFracture_Swelling);
        _hintLog = LLSTRING(InspectFracture_Swelling_Short);
    };
    case (_fractureState == ACM_FRACTURE_MILD): {
        _hint = LLSTRING(InspectFracture_SevereBruising);
        _hintLog = LLSTRING(InspectFracture_SevereBruising_Short);
    };
    case (_bodyPartDamage > 1): {
        _hint = LLSTRING(InspectFracture_Bruised);
        _hintLog = LLSTRING(InspectFracture_Bruised_Short);
    };
    default {
        _hint = LLSTRING(InspectFracture_NoInjury);
        _hintLog = LLSTRING(InspectFracture_NoInjury_Short);
    };
};

private _preparedArray = _patient getVariable [QGVAR(Fracture_Prepared), [false,false,false,false,false,false]];

if (_preparedArray select _partIndex) then {
    _hint = format ["%1<br />%2", _hint, LLSTRING(InspectFracture_RealignmentPerformed)];
    _hintLog = format ["%1, %2", _hintLog, LLSTRING(InspectFracture_RealignmentPerformed_Short)];
    _hintHeight = 2.5;
};

[_hint, _hintHeight, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "quick_view", LLSTRING(InspectFracture_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), (toLower _bodyPartString), _hintLog]] call ACEFUNC(medical_treatment,addToLog);