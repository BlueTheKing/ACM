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

private _hint = LLSTRING(InspectChest_Normal);
private _hintLog = LLSTRING(InspectChest_Normal);
private _hintSecondLog = "";
private _hintHeight = 1.5;

private _pneumothorax = _patient getVariable [QGVAR(Pneumothorax_State), 0] > 0;
private _tensionPneumothorax = _patient getVariable [QGVAR(TensionPneumothorax_State), false];
private _hemothorax = _patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 0.5;
private _tensionHemothorax = _patient getVariable [QGVAR(Hemothorax_Fluid), 0] > 1.4;

private _trachealDeviationTime = CBA_missionTime - (_patient getVariable [QGVAR(TensionPneumothorax_Time), CBA_missionTime]);

private _respiratoryArrest = (GET_RESPIRATION_RATE(_patient) < 1 || (GET_HEART_RATE(_patient) < 20) || !(alive _patient) || _tensionPneumothorax || _tensionHemothorax);
private _airwayBlocked = GET_AIRWAYSTATE(_patient) == 0;

private _secondEntry = false;

switch (true) do {
    case (_respiratoryArrest || _airwayBlocked): {
        _hint = LLSTRING(InspectChest_None);
        _hintLog = LLSTRING(InspectChest_None_Short);
        
        if (_pneumothorax || _tensionPneumothorax) then {
            _hint = format ["%1<br/>%2", _hint, LLSTRING(InspectChest_None_Uneven)];
            _hintLog = format ["%1, %2", _hintLog, LLSTRING(InspectChest_None_Uneven_Short)];
            _hintHeight = 2;

            if (_trachealDeviationTime > 200) then {
                _secondEntry = true;
                _hintHeight = 2.5;
                if (_trachealDeviationTime > 300) then {
                    _hint = format ["%1<br/>%2", _hint, LLSTRING(InspectChest_TrachealDeviation)];
                    _hintSecondLog = LLSTRING(InspectChest_TrachealDeviation_Short);
                } else {
                    _hint = format ["%1<br/>%2", _hint, LLSTRING(InspectChest_TrachealDeviation_Slight)];
                    _hintSecondLog = LLSTRING(InspectChest_TrachealDeviation_Slight_Short);
                };
            };
        };

        if (_hemothorax) then {
            _hint = format ["%1<br/>%2", _hint, LLSTRING(InspectChest_Bruising)];
            _hintLog = format ["%1, %2", _hintLog, toLower (LLSTRING(InspectChest_Bruising_Short))];
            _hintHeight = _hintHeight + 0.5;
        };
    };
    case (_pneumothorax): {
        _hint = LLSTRING(InspectChest_Uneven);
        _hintLog = LLSTRING(InspectChest_Uneven_Short);
    };
    case (_hemothorax): {
        _hint = format ["%1<br/>%2", LLSTRING(InspectChest_Uneven), LLSTRING(InspectChest_Bruising)];
        _hintLog = format ["%1, %2", LLSTRING(InspectChest_Uneven_Short), toLower (LLSTRING(InspectChest_Bruising_Short))];
        _hintHeight = 2.5;
    };
    default {};
};

[QACEGVAR(common,displayTextStructured), [_hint, _hintHeight, _medic], _medic] call CBA_fnc_targetEvent;
[_patient, "quick_view", LSTRING(InspectChest_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _hintLog]] call ACEFUNC(medical_treatment,addToLog);

if (_secondEntry) then {
    [_patient, "quick_view", LSTRING(InspectChest_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName), _hintSecondLog]] call ACEFUNC(medical_treatment,addToLog);
};
