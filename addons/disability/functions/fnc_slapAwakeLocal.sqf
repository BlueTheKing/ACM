#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle attempt to slap patient awake (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_disability_fnc_slapAwakeLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = "Patient is still asleep";

addCamShake [5, 0.3, 5];

_patient setVariable [QEGVAR(core,KnockOut_State), false];

//playSound3D [QPATHTO_R(sound\slap.wav), _patient, false, getPosASL _patient, 8, 1, 8];

if !([_patient] call ACEFUNC(medical_status,hasStableVitals)) exitWith {
    [format ["You slap the patient<br />%1", _hint], 2, _medic] call ACEFUNC(common,displayTextStructured);
};

private _oxygenSaturationChance = linearConversion [80, 99, GET_OXYGEN(_patient), 5, 40, true] ;

if (random 100 < _oxygenSaturationChance) then {
    [QACEGVAR(medical,WakeUp), _patient] call CBA_fnc_localEvent;
    _hint = "Patient has woken up";
};

[format ["You slap the patient<br />%1", _hint], 2, _medic] call ACEFUNC(common,displayTextStructured);