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

private _hint = LLSTRING(AttemptWakeUp_Failure);

addCamShake [5, 0.3, 5];

_patient setVariable [QEGVAR(core,KnockOut_State), false];

if (random 100 < 20) then {
    [_patient, 0.051, "head", "slap", _medic] call ACEFUNC(medical,addDamageToUnit);
};

if !([_patient] call ACEFUNC(medical_status,hasStableVitals)) exitWith {
    [QACEGVAR(common,displayTextStructured), [(format [LLSTRING(SlapPatient_Attempt), _hint]), 2, _medic], _medic] call CBA_fnc_targetEvent;
};

private _oxygenSaturationChance = linearConversion [80, 99, GET_OXYGEN(_patient), 0.05, 0.4, true] ;

if (random 1 < _oxygenSaturationChance) then {
    if (IS_UNCONSCIOUS(_patient)) then {
        [QEGVAR(core,playWakeUpSound), _patient] call CBA_fnc_localEvent;
        [QACEGVAR(medical,WakeUp), _patient] call CBA_fnc_localEvent;
    };
    _hint = LLSTRING(AttemptWakeUp_Success);
};

[QACEGVAR(common,displayTextStructured), [(format [LLSTRING(SlapPatient_Complete), _hint]), 2, _medic], _medic] call CBA_fnc_targetEvent;