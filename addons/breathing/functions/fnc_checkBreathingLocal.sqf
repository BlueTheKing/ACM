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

private _respirationRate = GET_RESPIRATION_RATE(_patient);

private _pneumothorax = _patient getVariable [QGVAR(Pneumothorax_State), 0] > 0;
private _tensionPneumothorax = _patient getVariable [QGVAR(TensionPneumothorax_State), false];
private _hemothorax = (_patient getVariable [QGVAR(Hemothorax_Fluid), 0]) > 1.4;

private _respiratoryArrest = (_respirationRate < 1 || (GET_HEART_RATE(_patient) < 20) || !(alive _patient) || _tensionPneumothorax || _hemothorax);
private _airwayBlocked = (GET_AIRWAYSTATE(_patient)) == 0;
private _airwayCollapsed = (_patient getVariable [QEGVAR(airway,AirwayCollapse_State), 0]) > 0;
private _airwayReflexIntact = _patient getVariable [QEGVAR(airway,AirwayReflex_State), false];

private _airwayManeuver = _patient getVariable [QEGVAR(airway,RecoveryPosition_State), false] || _patient getVariable [QEGVAR(airway,HeadTilt_State), false];
private _airwayAdjunct = (_patient getVariable [QEGVAR(airway,AirwayItem_Oral), ""]) == "OPA" || (_patient getVariable [QEGVAR(airway,AirwayItem_Nasal), ""]) == "NPA" || _airwayManeuver;
private _airwaySecure = (_patient getVariable [QEGVAR(airway,AirwayItem_Oral), ""]) == "SGA" || _airwayManeuver;

switch (true) do {
    case (_respiratoryArrest || _airwayBlocked): {
        _hint = "Patient is not breathing";
        _hintLog = "None";
    };
    case (_pneumothorax || _airwayCollapsed && !_airwaySecure || !_airwayReflexIntact && !_airwayAdjunct): {
        _hint = "Patient breathing is shallow";
        _hintLog = "Shallow";

        if (_respirationRate < 15.9) then {
            _hint = "Patient breathing is slow and shallow";
            _hintLog = "Slow and shallow";
        } else {
            if (_respirationRate > 22) then {
                _hint = "Patient breathing is rapid and shallow";
                _hintLog = "Rapid and shallow";
            };
        };
    };
    case (_respirationRate < 15.9): {
        _hint = "Patient breathing is slow";
        _hintLog = "Slow";
    };
    case (_respirationRate > 22): {
        _hint = "Patient breathing is rapid";
        _hintLog = "Rapid";
    };
    default {};
};

[QACEGVAR(common,displayTextStructured), [_hint, 1.5, _medic], _medic] call CBA_fnc_targetEvent;
[_patient, "quick_view", "%1 checked breathing: %2", [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);