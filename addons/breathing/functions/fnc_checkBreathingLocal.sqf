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

private _hint = LLSTRING(CheckBreathing_Normal);
private _hintLog = LLSTRING(CheckBreathing_Normal_Short);

private _respirationRate = GET_RESPIRATION_RATE(_patient);

private _pneumothorax = _patient getVariable [QGVAR(Pneumothorax_State), 0] > 0;
private _tensionPneumothorax = _patient getVariable [QGVAR(TensionPneumothorax_State), false];
private _tensionHemothorax = (_patient getVariable [QGVAR(Hemothorax_Fluid), 0]) > 1.4;

private _respiratoryArrest = (_respirationRate < 1 || (GET_HEART_RATE(_patient) < 20) || !(alive _patient) || _tensionPneumothorax || _tensionHemothorax);
private _airwayBlocked = (GET_AIRWAYSTATE(_patient)) == 0;
private _airwayCollapsed = (_patient getVariable [QEGVAR(airway,AirwayCollapse_State), 0]) > 0;
private _airwayReflexIntact = _patient getVariable [QEGVAR(airway,AirwayReflex_State), false];

private _airwayInflammation = GET_AIRWAY_INFLAMMATION(_patient) > AIRWAY_INFLAMMATION_THRESHOLD_MILD;
private _lungTissueDamaged = GET_LUNG_TISSUEDAMAGE(_patient) > LUNG_TISSUEDAMAGE_THRESHOLD_MILD;

private _airwayManeuver = _patient getVariable [QEGVAR(airway,RecoveryPosition_State), false] || _patient getVariable [QEGVAR(airway,HeadTilt_State), false];
private _airwayAdjunct = (_patient getVariable [QEGVAR(airway,AirwayItem_Oral), ""]) == "OPA" || (_patient getVariable [QEGVAR(airway,AirwayItem_Nasal), ""]) == "NPA" || _airwayManeuver;
private _airwaySecure = (_patient getVariable [QEGVAR(airway,AirwayItem_Oral), ""]) == "SGA" || _airwayManeuver;

private _hintHeight = 1.5;

switch (true) do {
    case (_respiratoryArrest || _airwayBlocked): {
        _hint = LLSTRING(CheckBreathing_None);
        _hintLog = LLSTRING(CheckBreathing_None_Short);
    };
    case (_pneumothorax || _airwayCollapsed && !_airwaySecure || !_airwaySecure && !_airwayReflexIntact && !_airwayAdjunct || _airwayInflammation || _lungTissueDamaged): {
        _hint = LLSTRING(CheckBreathing_Shallow);
        _hintLog = LLSTRING(CheckBreathing_Shallow_Short);

        if (_respirationRate < 15.9) then {
            _hint = LLSTRING(CheckBreathing_ShallowSlow);
            _hintLog = LLSTRING(CheckBreathing_ShallowSlow_Short);
            _hintHeight = 2;
        } else {
            if (_respirationRate > 22) then {
                _hint = LLSTRING(CheckBreathing_ShallowRapid);
                _hintLog = LLSTRING(CheckBreathing_ShallowRapid_Short);
                _hintHeight = 2;
            };
        };
    };
    case (_respirationRate < 15.9): {
        _hint = LLSTRING(CheckBreathing_Slow);
        _hintLog = LLSTRING(CheckBreathing_Slow_Short);
    };
    case (_respirationRate > 22): {
        _hint = LLSTRING(CheckBreathing_Rapid);
        _hintLog = LLSTRING(CheckBreathing_Rapid_Short);
    };
    default {};
};

[QACEGVAR(common,displayTextStructured), [_hint, _hintHeight, _medic], _medic] call CBA_fnc_targetEvent;
[_patient, "quick_view", LSTRING(CheckBreathing_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);