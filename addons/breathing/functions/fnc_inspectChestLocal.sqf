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
 * [player, cursorTarget] call ACM_breathing_fnc_inspectChestLocal;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _hintArray = ["%1", LSTRING(InspectChest_Normal)];
private _hintLogArray = [LSTRING(InspectChest_Normal)];
private _hintLogFormat = "%1";

private _hintSecondLog = "";
private _hintHeight = 1.5;

private _pneumothorax = _patient getVariable [QGVAR(Pneumothorax_State), 0] > 0;
private _tensionPneumothorax = _patient getVariable [QGVAR(TensionPneumothorax_State), false];
private _hemothorax = _patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0.5;
private _tensionHemothorax = _patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 1.4;

private _hasPneumothorax = _pneumothorax || _tensionPneumothorax;

private _trachealDeviationTime = CBA_missionTime - (_patient getVariable [QGVAR(TensionPneumothorax_Time), CBA_missionTime]);

private _respiratoryArrest = (GET_RESPIRATION_RATE(_patient) < 1 || (GET_HEART_RATE(_patient) < 20) || !(alive _patient) || _tensionPneumothorax || _tensionHemothorax);
private _airwayBlocked = GET_AIRWAYSTATE(_patient) == 0;

private _secondEntry = false;

switch (true) do {
    case (_respiratoryArrest || _airwayBlocked): {
        _hintArray set [1, LSTRING(InspectChest_None)];
        _hintLogArray set [0, LSTRING(InspectChest_None_Short)];
        
        if (_hasPneumothorax) then {
            _hintArray set [0, "%1<br/>%2"];
            _hintArray pushBack LSTRING(InspectChest_None_Uneven);

            _hintLogArray pushBack LSTRING(InspectChest_None_Uneven_Short);
            _hintLogFormat = "%1, %2";

            _hintHeight = 2;

            if (_trachealDeviationTime > 200) then {
                _secondEntry = true;
                _hintHeight = 2.5;

                _hintArray set [0, "%1<br/>%2<br/>%3"];

                if (_trachealDeviationTime > 300) then {
                    _hintArray pushBack LSTRING(InspectChest_TrachealDeviation);

                    _hintSecondLog = LSTRING(InspectChest_TrachealDeviation_Short);
                } else {
                    _hintArray pushBack LSTRING(InspectChest_TrachealDeviation_Slight);

                    _hintSecondLog = LSTRING(InspectChest_TrachealDeviation_Slight_Short);
                };
            };
        };

        if (_hemothorax) then {
            _hintHeight = _hintHeight + 0.5;

            _hintArray set [0, (["%1<br/>%2",
                (["%1<br/>%2<br/>%3","%1<br/>%2<br/>%3<br/>%4"] select _secondEntry)
            ] select _hasPneumothorax)];

            _hintArray pushBack LSTRING(InspectChest_Bruising);

            _hintLogArray pushBack LSTRING(InspectChest_Bruising_Short);
            _hintLogFormat = ["%1, %2", "%1, %2, %3"] select _hasPneumothorax;
        };
    };
    case (_pneumothorax): {
        _hintArray pushBack LSTRING(InspectChest_Uneven);
        _hintLogArray pushBack LSTRING(InspectChest_Uneven_Short);
    };
    case (_hemothorax): {
        _hintHeight = 2.5;

        _hintArray set [0, "%1<br/>%2"];
        _hintArray append [LSTRING(InspectChest_Uneven), LSTRING(InspectChest_Bruising)];

        _hintLogArray append [LSTRING(InspectChest_Uneven_Short), LSTRING(InspectChest_Bruising_Short)];
        _hintLogFormat = "%1, %2";
    };
    default {};
};

private _logArray = [[_medic, false, true] call ACEFUNC(common,getName), LSTRING(InspectChest_ActionLog)];

[QACEGVAR(common,displayTextStructured), [_hintArray, _hintHeight, _medic], _medic] call CBA_fnc_targetEvent;
[_patient, "quick_view", _hintLogFormat, (_logArray + _hintLogArray)] call ACEFUNC(medical_treatment,addToLog);

if (_secondEntry) then {
    [_patient, "quick_view", _hintLogFormat, (_logArray + _hintSecondLog)] call ACEFUNC(medical_treatment,addToLog);
};
