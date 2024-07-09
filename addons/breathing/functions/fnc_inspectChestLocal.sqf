#include "..\script_component.hpp"
/*
 * Author: Blue
 * Inspect chest of patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_inspectChestLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = "Chest rise and fall observed";
private _hintLog = "Chest rise and fall observed";
private _hintHeight = 1.5;

private _pneumothorax = _patient getVariable [QGVAR(Pneumothorax_State), 0] > 0;
private _tensionPneumothorax = _patient getVariable [QGVAR(TensionPneumothorax_State), false];
private _hemothorax = _patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0.5;
private _tensionHemothorax = _patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 1.4;

private _respiratoryArrest = (GET_RESPIRATION_RATE(_patient) < 1 || (GET_HEART_RATE(_patient) < 20) || !(alive _patient) || _tensionPneumothorax || _tensionHemothorax);
private _airwayBlocked = GET_AIRWAYSTATE(_patient) == 0;

switch (true) do {
    case (_respiratoryArrest || _airwayBlocked): {
        _hint = "No chest movement observed";
        _hintLog = "No chest movement";
        
        if (_pneumothorax || _tensionPneumothorax) then {
            _hint = format ["%1<br/>%2", _hint, "Chest sides are uneven"];
            _hintLog = format ["%1%2", _hintLog, ", chest sides uneven"];
            _hintHeight = 2;
        };

        if (_hemothorax) then {
            _hint = format ["%1<br/>%2", _hint, "Noticable extensive bruising"];
            _hintLog = format ["%1%2", _hintLog, ", extensive bruising"];
            _hintHeight = _hintHeight + 0.5;
        };
    };
    case (_pneumothorax): {
        _hint = "Uneven chest rise and fall observed";
        _hintLog = "Uneven chest rise and fall";
    };
    case (_hemothorax): {
        _hint = "Uneven chest rise and fall observed<br/>Noticable extensive bruising";
        _hintLog = "Uneven chest rise and fall, extensive bruising";
        _hintHeight = 2.5;
    };
    default {};
};

[QACEGVAR(common,displayTextStructured), [_hint, _hintHeight, _medic], _medic] call CBA_fnc_targetEvent;
[_patient, "quick_view", "%1 inspected chest: %2", [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);
