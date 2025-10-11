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
 * [player, cursorTarget] call ACM_airway_fnc_checkAirway;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hintArray = [LSTRING(CheckAirway_AirwayIsClear)];
private _hintFormat = "%1";

private _hintLogArray = [LSTRING(CheckAirway_AirwayIsClear_Short)];
private _hintLogArrayAdditional = [];
private _hintLogFormat = "%1 %2: %3";
private _hintLogFormatAdditional = "%1 %2: %3";

private _airwayCollapseState = _patient getVariable [QGVAR(AirwayCollapse_State), 0];
private _obstructionVomitState = _patient getVariable [QGVAR(AirwayObstructionVomit_State), 0];
private _obstructionBloodState = _patient getVariable [QGVAR(AirwayObstructionBlood_State), 0];

private _airwayItemInsertedOral = _patient getVariable [QGVAR(AirwayItem_Oral), ""];
private _airwayItemInsertedNasal = _patient getVariable [QGVAR(AirwayItem_Nasal), ""];

private _airwayInflammationState = GET_AIRWAY_INFLAMMATION(_patient);

private _collapseManaged = false;
private _airwaySecure = false;

private _showManeuver = false;

private _maneuverHint = "";
private _maneuverHintLog = "";

if (_patient getVariable [QGVAR(RecoveryPosition_State), false]) then {
    _showManeuver = true;
    _collapseManaged = true;
    _maneuverHint = LSTRING(CheckAirway_RecoveryPosition);
    _maneuverHintLog = LSTRING(CheckAirway_RecoveryPosition_Short);
} else {
    if (_patient getVariable [QGVAR(HeadTilt_State), false]) then {
        _showManeuver = true;
        _collapseManaged = true;
        _maneuverHint = LSTRING(CheckAirway_HeadTiltChinLift);
        _maneuverHintLog = LSTRING(CheckAirway_HeadTiltChinLift_Short);
    };
};

private _showAdjunct = false;
private _doubleAdjunct = false;

private _oralAdjunct = "";
private _nasalAdjunct = "";

if (_airwayItemInsertedOral != "" || _airwayItemInsertedNasal != "") then {
    _showAdjunct = true;

    if (_airwayItemInsertedOral != "") then {

        _oralAdjunct = (switch (_airwayItemInsertedOral) do {
            case "OPA": {
                LSTRING(OPA);
            };
            default {
                _airwaySecure = true;
                LSTRING(IGel);
            };
        });
    };

    if (_airwayItemInsertedNasal == "NPA") then {
        _nasalAdjunct = LSTRING(NPA);
    };

    _doubleAdjunct = (_oralAdjunct != "" && _nasalAdjunct != "");
};

private _showObstruction = false;

private _obstructionState = "";
private _obstructionStateLog = "";

if (_obstructionVomitState > 0 || _obstructionBloodState > 0) then {
    _showObstruction = true;
    _obstructionState = LSTRING(CheckAirway_Obstruction_Light);
    _obstructionStateLog = LSTRING(CheckAirway_Obstruction_Light_Short);
    
    if (_obstructionVomitState > 1 || _obstructionBloodState > 1) then {
        _obstructionState = LSTRING(CheckAirway_Obstruction);
        _obstructionStateLog = LSTRING(CheckAirway_Obstruction_Short);
    };
};

private _showInflammation = _airwayInflammationState > AIRWAY_INFLAMMATION_THRESHOLD_MILD;

private _inflammationState = "";
private _inflammationStateLog = "";

if (_showInflammation) then {
    switch (true) do {
        case (_airwayInflammationState > AIRWAY_INFLAMMATION_THRESHOLD_SEVERE): {
            _inflammationState = LSTRING(CheckAirway_Inflammation_Severe);
            _inflammationStateLog = LSTRING(CheckAirway_Inflammation_Severe_Short);
        };
        case (_airwayInflammationState > AIRWAY_INFLAMMATION_THRESHOLD_SERIOUS): {
            _inflammationState = LSTRING(CheckAirway_Inflammation_Serious);
            _inflammationStateLog = LSTRING(CheckAirway_Inflammation_Serious_Short);
        };
        default {
            _inflammationState = LSTRING(CheckAirway_Inflammation_Mild);
            _inflammationStateLog = LSTRING(CheckAirway_Inflammation_Mild_Short);
        };
    };
};

_collapseManaged = _collapseManaged || _airwaySecure;

private _showCollapse = _airwayCollapseState > 0;

private _collapseState = "";
private _collapseStateLog = "";

if (!_showInflammation && !_collapseManaged) then {
    if (_showCollapse) then {

        switch (_airwayCollapseState) do {
            case 1: {
                _collapseState = LSTRING(CheckAirway_Collapse_Mild);
                _collapseStateLog = LSTRING(CheckAirway_Collapse_Mild_Short);
            };
            case 2: {
                _collapseState = LSTRING(CheckAirway_Collapse_Moderate);
                _collapseStateLog = LSTRING(CheckAirway_Collapse_Moderate_Short);
            };
            case 3: {
                _collapseState = LSTRING(CheckAirway_Collapse_Severe);
                _collapseStateLog = LSTRING(CheckAirway_Collapse_Severe_Short);
            };
        };
    };
} else {
    _showCollapse = false;
};

private _hintHeight = 1.5;
private _rowCount = 0;

private _doubleSpace = false;

if (_showManeuver || _showAdjunct || _showObstruction || _showInflammation || _showCollapse) then {
    private _entryCount = 0;
    private _startEntryCount = 1;

    private _entryCountLog = 0;
    private _startEntryCountLog = 1;

    _hintArray = [];
    _hintLogArray = [];

    if (_showManeuver) then {
        _entryCount = _entryCount + 1;
        _rowCount = _rowCount + 1;

        _hintArray pushBack _maneuverHint;
        _hintLogArray pushBack _maneuverHintLog;
    };

    if (_showAdjunct) then {
        _entryCount = _entryCount + 2;
        _rowCount = _rowCount + 1;

        if (_doubleAdjunct) then {
            _hintArray append [_oralAdjunct, _nasalAdjunct, LSTRING(CheckAirway_%1_Inserted)];
            _hintLogArray append [_oralAdjunct, _nasalAdjunct, LSTRING(CheckAirway_%1_Inserted)];

            if (_showManeuver) then {
                _entryCount = 4;
                _startEntryCount = 4;
                _hintFormat = "%1<br/>%2 &amp; %3 %4";
                _hintLogFormat = "%1 %2: %3, %4 & %5 %6";
            } else {
                _entryCount = 3;
                _startEntryCount = 3;
                _hintFormat = "%1 &amp; %2 %3";
                _hintLogFormat = "%1 %2: %3 & %4 %5";
            };
        } else {
            _hintArray pushBack ([_nasalAdjunct, _oralAdjunct] select (_oralAdjunct != ""));
            _hintArray pushBack LSTRING(CheckAirway_%1_Inserted);

            _hintLogArray pushBack ([_nasalAdjunct, _oralAdjunct] select (_oralAdjunct != ""));
            _hintLogArray pushBack LSTRING(CheckAirway_%1_Inserted);

            if (_showManeuver) then {
                _entryCount = 3;
                _startEntryCount = 3;
                _hintFormat = "%1<br/>%2 %3";
                _hintLogFormat = "%1 %2: %3, %4 %5";
            } else {
                _entryCount = 2;
                _startEntryCount = 2;
                _hintFormat = "%1 %2";
                _hintLogFormat = "%1 %2: %3 %4";
            };
        };
    };

    if (((_showManeuver && _showAdjunct) || _doubleAdjunct) && _showInflammation && _showObstruction) then {
        _doubleSpace = true;

        _hintLogArrayAdditional = _hintLogArray;
        _hintLogArray = [];

        _hintLogFormat = "%1 %2 (%3): %4";

        _hintLogFormatAdditional = (switch (true) do {
            case (_doubleAdjunct && _showManeuver): {
                "%1 %2 (%3): %4, %5 & %6 %7";
            };
            case (_doubleAdjunct && !_showManeuver): {
                "%1 %2 (%3): %4 & %5 %6";
            };
            case (!_doubleAdjunct && _showManeuver): {
                "%1 %2 (%3): %4, %5 %6";
            };
            default {
                "%1";
            };
        });

        _entryCountLog = _entryCountLog + 1;
        _startEntryCountLog = _startEntryCountLog + 1;
    } else {
        _entryCountLog = _entryCount;
        _startEntryCountLog = _startEntryCount;
    };

    if (_showObstruction) then {
        _entryCount = _entryCount + 1;
        _rowCount = _rowCount + 1;

        _entryCountLog = _entryCountLog + 1;

        _hintArray pushBack _obstructionState;
        _hintLogArray pushBack _obstructionStateLog;
    };

    if (_showInflammation) then {
        _entryCount = _entryCount + 1;
        _rowCount = _rowCount + 1;

        _entryCountLog = _entryCountLog + 1;

        _hintArray pushBack _inflammationState;
        _hintLogArray pushBack _inflammationStateLog;
    } else {
        if (_showCollapse) then {
            _entryCount = _entryCount + 1;
            _rowCount = _rowCount + 1;

            _entryCountLog = _entryCountLog + 1;

            _hintArray pushBack _collapseState;
            _hintLogArray pushBack _collapseStateLog;
        };
    };

    _hintHeight = 1 + _rowCount * 0.5;

    for "_i" from (_startEntryCount + 1) to _entryCount do {
        _hintFormat = format ["%1<br/>%2", _hintFormat, (format ["%%%1", _i])];
    };

    for "_i" from (_startEntryCountLog + 1) to _entryCountLog do {
        _hintLogFormat = format ["%1, %2", _hintLogFormat, (format ["%%%1", (_i + 2)])];
    };
};

private _logArray = [[_medic, false, true] call ACEFUNC(common,getName), LSTRING(CheckAirway_ActionLog)];

[([_hintFormat] + _hintArray), _hintHeight, _medic] call ACEFUNC(common,displayTextStructured);

if (_doubleSpace) then {
    [_patient, "quick_view", _hintLogFormatAdditional, (_logArray + [1] + _hintLogArrayAdditional)] call ACEFUNC(medical_treatment,addToLog);
    [_patient, "quick_view", _hintLogFormat, (_logArray + [2] + _hintLogArray)] call ACEFUNC(medical_treatment,addToLog);
} else {
    [_patient, "quick_view", _hintLogFormat, (_logArray + _hintLogArray)] call ACEFUNC(medical_treatment,addToLog);
};

_patient setVariable [QGVAR(AirwayChecked_Time), CBA_missionTime, true];