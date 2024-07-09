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

if (random 100 < 20) then {
    [_patient, 0.051, "head", "slap", _medic] call ACEFUNC(medical,addDamageToUnit);
};

if !([_patient] call ACEFUNC(medical_status,hasStableVitals)) exitWith {
    [QACEGVAR(common,displayTextStructured), [(format ["You slap the patient<br />%1", _hint]), 2, _medic], _medic] call CBA_fnc_targetEvent;
};

private _oxygenSaturationChance = linearConversion [80, 99, GET_OXYGEN(_patient), 5, 40, true] ;

if (random 100 < _oxygenSaturationChance) then {
    if (IS_UNCONSCIOUS(_patient)) then {
        [QEGVAR(core,playWakeUpSound), _patient] call CBA_fnc_localEvent;
        [QACEGVAR(medical,WakeUp), _patient] call CBA_fnc_localEvent;
    };
    _hint = "Patient has woken up";
};

[QACEGVAR(common,displayTextStructured), [(format ["You slap the patient<br />%1", _hint]), 2, _medic], _medic] call CBA_fnc_targetEvent;