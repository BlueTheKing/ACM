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
 * [player, cursorTarget] call AMS_breathing_fnc_inspectChestLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = "Chest rise and fall observed";
private _hintLog = "Chest rise and fall observed";

private _pneumothorax = _patient getVariable [QGVAR(Pneumothorax_State), 0] > 0;
private _tensionPneumothorax = _patient getVariable [QGVAR(TensionPneumothorax_State), false];

private _respiratoryArrest = (IN_CRDC_ARRST(_patient) || !(alive _patient) || _tensionPneumothorax);
private _airwayBlocked = !(_patient getVariable [QEGVAR(airway,AirwayState), 0] > 0);

switch (true) do {
    case (_respiratoryArrest || _airwayBlocked): {
        _hint = "No chest movement observed";
        _hintLog = "No chest movement";
        
        if (_pneumothorax || _tensionPneumothorax) then {
            _hint = format ["%1<br/>%2",_hint, "Chest sides are uneven"];
            _hintLog = format ["%1%2",_hintLog, ", chest sides uneven"];
        };
    };
    case (_pneumothorax): {
        _hint = "Uneven chest rise and fall observed";
        _hintLog = "Uneven chest rise and fall";
    };
    default {};
};

[_hint, 1.5, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "quick_view", "%1 inspected chest: %2", [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);
