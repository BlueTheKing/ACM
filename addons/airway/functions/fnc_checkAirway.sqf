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

private _hint = LLSTRING(CheckAirway_AirwayIsClear);
private _hintLog = LLSTRING(CheckAirway_AirwayIsClear_Short);
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
    _maneuverHint = LLSTRING(CheckAirway_RecoveryPosition);
    _maneuverHintLog = LLSTRING(CheckAirway_RecoveryPosition_Short);
} else {
    if (_patient getVariable [QGVAR(HeadTilt_State), false]) then {
        _showManeuver = true;
        _collapseManaged = true;
        _maneuverHint = LLSTRING(CheckAirway_HeadTiltChinLift);
        _maneuverHintLog = LLSTRING(CheckAirway_HeadTiltChinLift_Short);
    };
};

private _showAdjunct = false;

private _adjunctHint = "";
private _adjunctHintLog = "";

if (_airwayItemInsertedOral != "" || _airwayItemInsertedNasal != "") then {
    _showAdjunct = true;

    private _nasal = "";
    if (_airwayItemInsertedNasal == "NPA") then {
        _nasal = LLSTRING(NPA);
    };

    private _oral = "";

    switch (_airwayItemInsertedOral) do {
        case "OPA": {
            _oral = LLSTRING(GuedelTube);
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
            _oral = LLSTRING(IGel);
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

    _adjunctHint = format [LLSTRING(CheckAirway_%1_Inserted), _adjunctHint];
    _adjunctHintLog = format [LLSTRING(CheckAirway_%1_Inserted), _adjunctHintLog];
};

_collapseManaged = _collapseManaged || _airwaySecure;

if !(_collapseManaged) then {
    if (_collapseShow) then {
        switch (_airwayCollapseState) do {
            case 1: {
                _collapseState = LLSTRING(CheckAirway_Collapse_Mild);
                _collapseStateLog = LLSTRING(CheckAirway_Collapse_Mild_Short);
            };
            case 2: {
                _collapseState = LLSTRING(CheckAirway_Collapse_Moderate);
                _collapseStateLog = LLSTRING(CheckAirway_Collapse_Moderate_Short);
            };
            case 3: {
                _collapseState = LLSTRING(CheckAirway_Collapse_Severe);
                _collapseStateLog = LLSTRING(CheckAirway_Collapse_Severe_Short);
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
    _obstructionState = LLSTRING(CheckAirway_Obstruction_Light);
    _obstructionStateLog = LLSTRING(CheckAirway_Obstruction_Light_Short);
    if (_obstructionVomitState > 1 || _obstructionBloodState > 1) then {
        _obstructionState = LLSTRING(CheckAirway_Obstruction);
        _obstructionStateLog = LLSTRING(CheckAirway_Obstruction_Short);
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
    [_patient, "quick_view", LLSTRING(CheckAirway_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _addHintLog]] call ACEFUNC(medical_treatment,addToLog);
    [_patient, "quick_view", LLSTRING(CheckAirway_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _doubleSpaceLog]] call ACEFUNC(medical_treatment,addToLog);
} else {
    [_patient, "quick_view", LLSTRING(CheckAirway_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);
};