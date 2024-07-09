#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform (finger) thoracostomy on patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_startLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = "Finger Thoracostomy Performed";
private _height = 2.5;
private _diagnose = "";
private _hintLog = "";

private _RR = GET_RESPIRATION_RATE(_patient);

switch (true) do {
    case (_patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0.8): {
        _height = 3;
        _diagnose = "Large amount of blood in pleural space<br/>Lung is severely collapsed";
        _hintLog = "Lung is collapsed, large amount of blood";
    };
    case (_patient getVariable [QGVAR(TensionPneumothorax_State), false]): {
        _diagnose = "Lung is severely collapsed";
        _hintLog = "Lung is collapsed";
    };
    case (_patient getVariable [QGVAR(Hemothorax_State), 0] > 0): {
        _diagnose = "Noticable bleeding inside pleural space";
        _hintLog = "Bleeding in pleural space";
    };
    case (_patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0): {
        _height = 3;
        if (_RR < 1) then {
            _diagnose = "Found blood in pleural space<br/>Lung is not inflating";
            _hintLog = "Blood in pleural space, lung is not inflating";
        } else {
            _diagnose = "Found blood in pleural space<br/>Lung is inflating normally";
            _hintLog = "Blood in pleural space, lung inflating normally";
        };
    };
    case (_RR < 1): {
        _diagnose = "Lung is not inflating";
        _hintLog = "Lung is not inflating";
    };
    default {
        _diagnose = "Lung is inflating normally";
        _hintLog = "Lung is inflating normally";
    };
};

[QACEGVAR(common,displayTextStructured), [(format ["%1<br/><br/>%2", _hint, _diagnose]), _height, _medic, 13], _medic] call CBA_fnc_targetEvent;
[_patient, "quick_view", "Thoracostomy Sweep: %1", [_hintLog]] call ACEFUNC(medical_treatment,addToLog);

_patient setVariable [QGVAR(Thoracostomy_State), 1, true];

private _anestheticEffect = [_patient, "Lidocaine", false] call ACEFUNC(medical_status,getMedicationCount);

if (_anestheticEffect < 0.5) then {
    [_patient, (1 - _anestheticEffect)] call ACEFUNC(medical,adjustPainLevel);
    [QACEGVAR(medical,CriticalVitals), _patient] call CBA_fnc_localEvent;
};

_patient setVariable [QGVAR(TensionPneumothorax_State), false, true];
_patient setVariable [QGVAR(Pneumothorax_State), 4, true];

[_patient] call FUNC(updateBreathingState);