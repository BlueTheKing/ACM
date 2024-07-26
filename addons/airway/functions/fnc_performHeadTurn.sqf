#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform head turn on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_airway_fnc_performHeadTurn;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hint = format ["%1<br />%2", LLSTRING(HeadTurn_Performed), LLSTRING(HeadTurn_AirwayIsClear)];

private _obstructionVomitState = _patient getVariable [QGVAR(AirwayObstructionVomit_State), 0];
private _obstructionBloodState = _patient getVariable [QGVAR(AirwayObstructionBlood_State), 0];

if (_obstructionVomitState > 0 || _obstructionBloodState > 0) then {
    private _tooSevere = false;

    if (_obstructionVomitState < 2) then {
        _patient setVariable [QGVAR(AirwayObstructionVomit_State), 0];
        _patient setVariable [QGVAR(AirwayObstructionVomit_GracePeriod), CBA_missionTime, true];
    } else {
        _tooSevere = true;
    };

    if (_obstructionBloodState < 2) then {
        _patient setVariable [QGVAR(AirwayObstructionBlood_State), 0];
    } else {
        _tooSevere = true;
    };

    if (_tooSevere) then {
        _hint = format ["%1<br />%2", LLSTRING(HeadTurn_Performed), LLSTRING(HeadTurn_SuctionRequired)];
    } else {
        _hint = format ["%1<br />%2", LLSTRING(HeadTurn_Performed), LLSTRING(HeadTurn_AirwayCleared)];
    };
};

[_hint, 2, _medic] call ACEFUNC(common,displayTextStructured);
[_patient, "activity", LSTRING(HeadTurn_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);