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
 * [player, cursorTarget] call ACM_airway_fnc_action_checkAirway;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = "Airway is clear";
private _hintLog = "Clear";
private _hintHeight = 1.5;

private _collapseState = "";
private _collapseStateLog = "";
private _obstructionState = "";
private _obstructionStateLog = "";

private _collapseShow = false;
private _obstructionShow = false;

private _airwayCollapseState = _patient getVariable [QGVAR(AirwayCollapse_State), 0];
private _airwayItemInsertedOral = _patient getVariable [QGVAR(AirwayItem_Oral), ""];
private _airwayItemInsertedNasal = _patient getVariable [QGVAR(AirwayItem_Nasal), ""];

if (_airwayItemInsertedOral != "" || _airwayItemInsertedNasal != "") then {
    _collapseShow = true;

    private _nasal = "";
    if (_airwayItemInsertedNasal == "NPA") then {
        _nasal = "NPA";
    };

    private _oral = "";

    switch (_airwayItemInsertedOral) do {
        case "OPA": {
            _oral = "Guedel Tube";
            if (_nasal == "NPA") then {
                _collapseState = format ["%1 &amp; %2", _nasal, _oral];
                _collapseStateLog = format ["%1 & %2", _nasal, _oral];
            } else {
                _collapseState = _oral;
                _collapseStateLog = _oral;
            };
        };
        case "SGA": {
            _oral = "i-gel";
            if (_nasal == "NPA") then {
                _collapseState = format ["%1 &amp; %2", _nasal, _oral];
                _collapseStateLog = format ["%1 & %2", _nasal, _oral];
            } else {
                _collapseState = _oral;
                _collapseStateLog = _oral;
            };
        };
        default {
            _collapseState = _nasal;
            _collapseStateLog = _nasal;
        };
    };

    _collapseState = format ["%1 Inserted", _collapseState];
    _collapseStateLog = format ["%1 Inserted", _collapseStateLog];
} else {
    _collapseShow = (_airwayCollapseState > 0);
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
};

if (_airwayItemInsertedOral == "SGA") then {
    _obstructionState = "";
} else {
    private _obstructionVomitState = _patient getVariable [QGVAR(AirwayObstructionVomit_State), 0];
    private _obstructionBloodState = _patient getVariable [QGVAR(AirwayObstructionBlood_State), 0];

    if (_obstructionVomitState > 0 || _obstructionBloodState > 0) then {
        _hintHeight = 2;
        _obstructionShow = true;
        _obstructionState = "Airway lightly obstructed";
        _obstructionStateLog = ", Light obstruction";
        if (_obstructionVomitState > 1 || _obstructionBloodState > 1) then {
            _obstructionState = "Airway obstructed";
            _obstructionStateLog = ", Obstruction";
        };
    };
};

if (_collapseShow || _obstructionShow) then {
    _hint = format ["%1<br />%2", _collapseState, _obstructionState];
    _hintLog = format ["%1%2", _collapseStateLog, _obstructionStateLog];
};

[_hint, _hintHeight, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "quick_view", "%1 checked airway: %2", [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);