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

private _airwayCollapseState = _patient getVariable [QGVAR(AirwayCollapse_State), 0];
private _airwayItemInsertedOral = _patient getVariable [QGVAR(AirwayItem_Oral), ""];
private _airwayItemInsertedNasal = _patient getVariable [QGVAR(AirwayItem_Nasal), ""];

private _collapseShow = _airwayCollapseState > 0;
private _obstructionShow = false;

private _collapseManaged = false;
private _airwaySecure = false;

private _showManeuver = false;

private _maneuverHint = "";
private _maneuverHintLog = "";

if (_patient getVariable [QGVAR(RecoveryPosition_State), false]) then {
    _showManeuver = true;
    _collapseManaged = true;
    _maneuverHint = "In Recovery Position";
    _maneuverHintLog = "In Recovery";
} else {
    if (_patient getVariable [QGVAR(HeadTilt_State), false]) then {
        _showManeuver = true;
        _collapseManaged = true;
        _maneuverHint = "Head Tilted-Chin Lifted";
        _maneuverHintLog = "Head Tilted";
    };
};

private _showAdjunct = false;

private _adjunctHint = "";
private _adjunctHintLog = "";

if (_airwayItemInsertedOral != "" || _airwayItemInsertedNasal != "") then {
    _showAdjunct = true;

    private _nasal = "";
    if (_airwayItemInsertedNasal == "NPA") then {
        _nasal = "NPA";
    };

    private _oral = "";

    switch (_airwayItemInsertedOral) do {
        case "OPA": {
            _oral = "Guedel Tube";
            if (_nasal == "NPA") then {
                _adjunctHint = format ["%1 &amp; %2", _nasal, _oral];
                _adjunctHintLog = format ["%1 & %2", _nasal, _oral];
            } else {
                _adjunctHint = _oral;
                _adjunctHintLog = _oral;
            };
        };
        case "SGA": {
            _airwaySecure = true;
            _oral = "i-gel";
            if (_nasal == "NPA") then {
                _adjunctHint = format ["%1 &amp; %2", _nasal, _oral];
                _adjunctHintLog = format ["%1 & %2", _nasal, _oral];
            } else {
                _adjunctHint = _oral;
                _adjunctHintLog = _oral;
            };
        };
        default {
            _adjunctHint = _nasal;
            _adjunctHintLog = _nasal;
        };
    };

    _adjunctHint = format ["%1 Inserted", _adjunctHint];
    _adjunctHintLog = format ["%1 Inserted", _adjunctHintLog];
};

_collapseManaged = _collapseManaged || _airwaySecure;

if !(_collapseManaged) then {
    if (_collapseShow) then {
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
        };
    };
} else {
    _collapseShow = false;
};

private _obstructionVomitState = _patient getVariable [QGVAR(AirwayObstructionVomit_State), 0];
private _obstructionBloodState = _patient getVariable [QGVAR(AirwayObstructionBlood_State), 0];

if (_obstructionVomitState > 0 || _obstructionBloodState > 0) then {
    _obstructionShow = true;
    _obstructionState = "Airway lightly obstructed";
    _obstructionStateLog = "Light obstruction";
    if (_obstructionVomitState > 1 || _obstructionBloodState > 1) then {
        _obstructionState = "Airway obstructed";
        _obstructionStateLog = "Obstruction";
    };
};

private _doubleSpace = false;
private _doubleSpaceLog = "";

private _addHint = "";
private _addHintLog = "";

if (_collapseShow || _obstructionShow || _showManeuver || _showAdjunct) then {
    _collapseShow = _collapseShow && !_airwaySecure;
    if (_collapseShow && _obstructionShow) then {
        _hintHeight = _hintHeight + 0.5;
        _hint = format ["%1<br />%2", _collapseState, _obstructionState];
        _hintLog = format ["%1, %2", _collapseStateLog, _obstructionStateLog];
    } else {
        if (_collapseShow || _obstructionShow) then {
            _hint = format ["%1%2", _collapseState, _obstructionState];
            _hintLog = format ["%1%2", _collapseStateLog, _obstructionStateLog];
        };
    };

    if (_showManeuver) then {
        if (_showAdjunct) then {
            if (_airwaySecure) then {
                _hintHeight = _hintHeight + 0.5;
                _addHint = _adjunctHint;
                _addHintLog = _adjunctHintLog;
            } else {
                _hintHeight = _hintHeight + 1;
                _addHint = format ["%1<br />%2", _maneuverHint, _adjunctHint];
                _addHintLog = format ["%1, %2", _maneuverHintLog, _adjunctHintLog];
            };
        } else {
            _hintHeight = _hintHeight + 0.5;
            _addHint = _maneuverHint;
            _addHintLog = _maneuverHintLog;
        };
    } else {
        if (_showAdjunct) then {
            _hintHeight = _hintHeight + 0.5;
            _addHint = _adjunctHint;
            _addHintLog = _adjunctHintLog;
        };
    };

    if (_addHint != "") then {
        _doubleSpaceLog = _hintLog;
        _hint = format ["%1<br />%2", _addHint, _hint];
        _hintLog = format ["%1, %2", _addHintLog, _hintLog];
    };

    if (_collapseShow && _obstructionShow && _showManeuver && _showAdjunct) then {
        _hintHeight = 3;
        _doubleSpace = true;
    };
};

[_hint, _hintHeight, _medic] call ACEFUNC(common,displayTextStructured);
if (_doubleSpace) then {
    [_patient, "quick_view", "%1 checked airway: %2", [[_medic, false, true] call ACEFUNC(common,getName), _addHintLog]] call ACEFUNC(medical_treatment,addToLog);
    [_patient, "quick_view", "%1 checked airway: %2", [[_medic, false, true] call ACEFUNC(common,getName), _doubleSpaceLog]] call ACEFUNC(medical_treatment,addToLog);
} else {
    [_patient, "quick_view", "%1 checked airway: %2", [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);
};