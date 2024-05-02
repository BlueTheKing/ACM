#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check breathing of patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_checkBreathingLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = "Patient is breathing normally";
private _hintLog = "Normal";

private _pneumothorax = _patient getVariable [QGVAR(Pneumothorax_State), 0] > 0;
private _tensionPneumothorax = _patient getVariable [QGVAR(TensionPneumothorax_State), false];

private _respiratoryArrest = ((GET_HEART_RATE(_patient) < 20) || !(alive _patient) || _tensionPneumothorax);
private _airwayBlocked = (GET_AIRWAYSTATE(_patient)) == 0;

switch (true) do {
    case (_respiratoryArrest || _airwayBlocked): {
        _hint = "Patient is not breathing";
        _hintLog = "None";
    };
    case (_pneumothorax || ((_patient getVariable [QEGVAR(airway,AirwayCollapse_State), 0]) > 0)): {
        _hint = "Patient breathing is shallow";
        _hintLog = "Shallow";
    };
    default {};
};

[_hint, 1.5, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "quick_view", "%1 checked breathing: %2", [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);