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
        _hint = "Patient has splint applied to limb";
        _hintLog = "Splinted";
    };
    case (_fractureState == ACM_FRACTURE_COMPLEX): {
        _hint = "Patient has significant swelling on limb";
        _hintLog = "Significant Swelling";
    };
    case (_fractureState == ACM_FRACTURE_SEVERE): {
        _hint = "Patient has swelling on limb";
        _hintLog = "Swelling";
    };
    case (_fractureState == ACM_FRACTURE_MILD): {
        _hint = "Patient has severe bruising on limb";
        _hintLog = "Severe Bruising";
    };
    case (_bodyPartDamage > 1): {
        _hint = "Patient limb is bruised";
        _hintLog = "Bruised";
    };
    default {
        _hint = "Patient has no substantial damage on limb";
        _hintLog = "No Significant Injury";
    };
};

private _preparedArray = _patient getVariable [QGVAR(Fracture_Prepared), [false,false,false,false,false,false]];

if (_preparedArray select _partIndex) then {
    _hint = format ["%1<br />%2", _hint, "Fracture realignment performed"];
    _hintLog = format ["%1, %2", _hintLog, "realignment performed"];
    _hintHeight = 2.5;
};

[_hint, _hintHeight, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "activity", "%1 inspected %2: %3", [[_medic, false, true] call ACEFUNC(common,getName), (toLower _bodyPartString), _hintLog]] call ACEFUNC(medical_treatment,addToLog);