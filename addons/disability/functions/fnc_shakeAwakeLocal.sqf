#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle attempt to shake patient awake (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_disability_fnc_shakeAwakeLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = LLSTRING(AttemptWakeUp_Failure);

addCamShake [2, 2, 5];

if !([_patient] call ACEFUNC(medical_status,hasStableVitals)) exitWith {
    [QACEGVAR(common,displayTextStructured), [(format [LSTRING(ShakePatient_Attempt), _hint]), 2, _medic], _medic] call CBA_fnc_targetEvent;
};

private _oxygenSaturationChance = linearConversion [80, 99, GET_OXYGEN(_patient), 1, 15, true] ;

if (random 100 < _oxygenSaturationChance) then {
    _patient setVariable [QEGVAR(core,KnockOut_State), false];
    [QACEGVAR(medical,WakeUp), _patient] call CBA_fnc_localEvent;
    _hint = LLSTRING(AttemptWakeUp_Success);
};

[QACEGVAR(common,displayTextStructured), [(format [LSTRING(ShakePatient_Complete), _hint]), 2, _medic], _medic] call CBA_fnc_targetEvent;