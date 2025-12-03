#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform fracture realignment on patient. (LOCAL)
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
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_performFractureRealignmentLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

playSound3D [format ["%1%2.wav", (QPATHTO_R(sound\crack)), (round (1 + (random 3)))], _patient, false, getPosASL _patient, 4, 1, 4]; // 0.432s

if (ACE_player == _patient) then {
    addCamShake [5, 0.4, 20];
};

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

private _anestheticEffect = linearConversion [0, 100, ([_patient, "Lidocaine", [ACM_ROUTE_IM], _partIndex] call EFUNC(circulation,getMedicationConcentration)), 0, 1, true];

if (_anestheticEffect < 0.7) then {
    [_patient, (1 - _anestheticEffect)] call ACEFUNC(medical,adjustPainLevel);
};

if (((_patient getVariable [QGVAR(Fracture_State), [0,0,0,0,0,0]]) select _partIndex) == 0) exitWith {
    [QACEGVAR(common,displayTextStructured), [LLSTRING(FractureRealignment_Complete), 2, _medic], _medic] call CBA_fnc_targetEvent;
};

[QACEGVAR(common,displayTextStructured), [LLSTRING(FractureRealignment_Complete_Success), 2, _medic], _medic] call CBA_fnc_targetEvent;

private _preparedArray = _patient getVariable [QGVAR(Fracture_Prepared), [false,false,false,false,false,false]];

if (_preparedArray select _partIndex) exitWith {};

private _noEffectArray = _patient getVariable [QGVAR(Fracture_NoEffect), [false,false,false,false,false,false]];

if (_noEffectArray select _partIndex) exitWith {};

_preparedArray set [_partIndex, true];
_patient setVariable [QGVAR(Fracture_Prepared), _preparedArray, true];