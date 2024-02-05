#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check airway state of patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call AMS_airway_fnc_action_checkAirway;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = "Airway is clear";
private _hintLog = "Clear";

private _collapseState = "";
private _collapseStateLog = "";
private _obstructionState = "";
private _obstructionStateLog = "";

private _airwayCollapseState = _patient getVariable [QGVAR(AirwayCollapse_State), 0];

if (_patient getVariable [QGVAR(AirwayItem), ""] == "") then {
    switch (_airwayCollapseState) do {
        case 1: {
            _collapseState = "Airway mildly collapsed";
            _collapseStateLog = "Mild collapse";
        };
        case 2: {
            _collapseState = "Airway moderately collapsed";
            _collapseStateLog = "Moderate collapse";
        };
        case 3: {
            _collapseState = "Airway severely collapsed";
            _collapseStateLog = "Severe collapse";
        };
        default {};
    };
} else {
    _collapseState = "Airway collapse mitigated";
    _collapseStateLog = "Collapse mitigated";
};

private _obstructionVomitState = _patient getVariable [QGVAR(AirwayObstructionVomit_State), 0];
private _obstructionBloodState = _patient getVariable [QGVAR(AirwayObstructionBlood_State), 0];

if (_obstructionVomitState > 0 || _obstructionBloodState > 0) then {
    _obstructionState = "Airway lightly obstructed";
    _obstructionStateLog = "Light obstruction";
    if (_obstructionVomitState > 1 || _obstructionBloodState > 1) then {
        _obstructionState = "Airway obstructed";
        _obstructionStateLog = "Obstruction";
    };
};

if (_airwayCollapseState > 0 || _obstructionVomitState > 0 || _obstructionBloodState > 0) then {
    _hint = format ["%1<br />%2", _collapseState, _obstructionState];
    _hintLog = format ["%1 %2", _collapseStateLog, _obstructionStateLog];
};

[_hint, 1.5, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "quick_view", "%1 checked airway: %2", [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);