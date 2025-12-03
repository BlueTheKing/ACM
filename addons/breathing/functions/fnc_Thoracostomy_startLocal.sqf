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

private _hint = LLSTRING(ThoracostomySweep_Complete);
private _height = 2.5;
private _diagnose = "";
private _hintLog = "";

private _RR = GET_RESPIRATION_RATE(_patient);

switch (true) do {
    case (_patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0.8): {
        _height = 3;
        _diagnose = format ["%1<br/>%2",LLSTRING(ThoracostomySweep_SevereBlood), LLSTRING(ThoracostomySweep_SevereCollapse)];
        _hintLog = format ["%1, %2",LLSTRING(ThoracostomySweep_SevereCollapse_Short), LLSTRING(ThoracostomySweep_SevereBlood_Short)];
    };
    case (_patient getVariable [QGVAR(TensionPneumothorax_State), false]): {
        _diagnose = LLSTRING(ThoracostomySweep_SevereCollapse);
        _hintLog = LLSTRING(ThoracostomySweep_SevereCollapse_Short);
    };
    case (_patient getVariable [QGVAR(Hemothorax_State), 0] > 0): {
        _diagnose = LLSTRING(ThoracostomySweep_Bleeding);
        _hintLog = LLSTRING(ThoracostomySweep_Bleeding_Short);
    };
    case (_patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0): {
        _height = 3;
        if (_RR < 1) then {
            _diagnose = format ["%1<br/>%2",LLSTRING(ThoracostomySweep_Blood), LLSTRING(ThoracostomySweep_NotInflating)];
            _hintLog = format ["%1, %2",LLSTRING(ThoracostomySweep_Blood_Short), toLower (LLSTRING(ThoracostomySweep_NotInflating))];
        } else {
            _diagnose = format ["%1<br/>%2",LLSTRING(ThoracostomySweep_Blood), LLSTRING(ThoracostomySweep_Normal)];
            _hintLog = format ["%1, %2",LLSTRING(ThoracostomySweep_Blood_Short), LLSTRING(ThoracostomySweep_Normal_Short)];
        };
    };
    case (_RR < 1 || !(alive _patient)): {
        _diagnose = LLSTRING(ThoracostomySweep_NotInflating);
        _hintLog = LLSTRING(ThoracostomySweep_NotInflating);
    };
    default {
        _diagnose = LLSTRING(ThoracostomySweep_Normal);
        _hintLog = LLSTRING(ThoracostomySweep_Normal);
    };
};

[QACEGVAR(common,displayTextStructured), [(format ["%1<br/><br/>%2", _hint, _diagnose]), _height, _medic, 13], _medic] call CBA_fnc_targetEvent;
[_patient, "quick_view", LLSTRING(ThoracostomySweep_ActionLog), [_hintLog]] call ACEFUNC(medical_treatment,addToLog);

_patient setVariable [QGVAR(Thoracostomy_State), 1, true];

private _anestheticEffect = ([_patient, "Lidocaine", [ACM_ROUTE_IM], BODYPART_INDEX_BODY] call EFUNC(circulation,getMedicationConcentration)) / 100;

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