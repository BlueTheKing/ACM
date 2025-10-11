#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform (finger) thoracostomy on patient. (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Used Kit <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_startLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_usedKit", false]];

private _hintArray = ["%1", LSTRING(ThoracostomySweep_Complete)];
private _hintLogArray = [];
private _hintLogFormat = "%1: %2";

private _height = 2.5;

private _RR = GET_RESPIRATION_RATE(_patient);

switch (true) do {
    case (_patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0.8): {
        _height = 3;

        _hintArray set [0, "%1<br/><br/>%2<br/>%3"];
        _hintArray append [LSTRING(ThoracostomySweep_SevereBlood), LSTRING(ThoracostomySweep_SevereCollapse)];

        _hintLogArray append [LSTRING(ThoracostomySweep_SevereCollapse_Short), LSTRING(ThoracostomySweep_SevereBlood_Short)];
        _hintLogFormat = "%1: %2, %3";
    };
    case (_patient getVariable [QGVAR(TensionPneumothorax_State), false]): {
        _hintArray set [0, "%1<br/><br/>%2"];
        _hintArray pushBack LSTRING(ThoracostomySweep_SevereCollapse);

        _hintLogArray pushBack LSTRING(ThoracostomySweep_SevereCollapse_Short);
    };
    case (_patient getVariable [QGVAR(Hemothorax_State), 0] > 0): {
        _hintArray set [0, "%1<br/><br/>%2"];
        _hintArray pushBack LSTRING(ThoracostomySweep_Bleeding);

        _hintLogArray pushBack LSTRING(ThoracostomySweep_Bleeding_Short);
    };
    case (_patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0): {
        _height = 3;

        _hintArray pushBack LSTRING(ThoracostomySweep_Blood);
        _hintLogArray pushBack LSTRING(ThoracostomySweep_Blood_Short);

        _hintLogFormat = "%1: %2, %3";

        if (_RR < 1) then {
            _hintArray set [0, "%1<br/><br/>%2<br/>%3"];
            _hintArray pushBack LSTRING(ThoracostomySweep_NotInflating);

            _hintLogArray pushBack LSTRING(ThoracostomySweep_NotInflating);
        } else {
            _hintArray set [0, "%1<br/><br/>%2<br/>%3"];
            _hintArray pushBack LSTRING(ThoracostomySweep_Normal);

            _hintLogArray pushBack LSTRING(ThoracostomySweep_Normal_Short);
        };
    };
    case (_RR < 1 || !(alive _patient)): {
        _hintArray set [0, "%1<br/><br/>%2"];
        _hintArray pushBack LSTRING(ThoracostomySweep_NotInflating);

        _hintLogArray pushBack LSTRING(ThoracostomySweep_NotInflating);
    };
    default {
        _hintArray set [0, "%1<br/><br/>%2"];
        _hintArray pushBack LSTRING(ThoracostomySweep_Normal);

        _hintLogArray pushBack LSTRING(ThoracostomySweep_Normal);
    };
};

private _logArray = [LSTRING(ThoracostomySweep_ActionLog)];
_logArray append _hintLogArray;

[QACEGVAR(common,displayTextStructured), [_hintArray, _height, _medic, 13], _medic] call CBA_fnc_targetEvent;
[_patient, "quick_view", _hintLogFormat, _logArray] call ACEFUNC(medical_treatment,addToLog);

_patient setVariable [QGVAR(Thoracostomy_State), 1, true];

private _anestheticEffect = [_patient, "Lidocaine", false, BODYPART_N_BODY] call ACEFUNC(medical_status,getMedicationCount);

if (_anestheticEffect < 0.7) then {
    [_patient, (1 - _anestheticEffect)] call ACEFUNC(medical,adjustPainLevel);
    if (_anestheticEffect < 0.5) then {
        [QACEGVAR(medical,CriticalVitals), _patient] call CBA_fnc_localEvent;
    };
};

_patient setVariable [QGVAR(Pneumothorax_State), 3, true];
_patient setVariable [QGVAR(TensionPneumothorax_State), false, true];
_patient setVariable [QGVAR(TensionPneumothorax_Time), nil, true];
_patient setVariable [QGVAR(Thoracostomy_UsedKit), _usedKit, true];
[_patient] call FUNC(updateLungState);