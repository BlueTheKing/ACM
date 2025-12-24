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

private _hintArray = ["%1<br/>%2", LSTRING(ShakePatient_Attempt), LSTRING(AttemptWakeUp_Failure)];

if (ACE_player == _patient) then {
    addCamShake [2, 2, 8];
};

if !(IS_UNCONSCIOUS(_patient)) exitWith {};

if (!([_patient] call ACEFUNC(medical_status,hasStableVitals)) || [_patient] call EFUNC(core,isForcedUnconscious)) exitWith {
    [QACEGVAR(common,displayTextStructured), [_hintArray, 2, _medic, 12.5], _medic] call CBA_fnc_targetEvent;
};

private _oxygenSaturationChance = linearConversion [90, 99, GET_OXYGEN(_patient), 0.3, 0.7, true] ;

if (random 1 < _oxygenSaturationChance) then {
    _patient setVariable [QEGVAR(core,KnockOut_State), false];
    [QACEGVAR(medical,WakeUp), _patient] call CBA_fnc_localEvent;
    _hintArray set [2, LSTRING(AttemptWakeUp_Success)];
};

[QACEGVAR(common,displayTextStructured), [_hintArray, 2, _medic, 12.5], _medic] call CBA_fnc_targetEvent;