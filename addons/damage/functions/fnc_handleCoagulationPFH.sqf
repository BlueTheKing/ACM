#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle coagulation (LOCAL)
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Coagulation was initiated by TXA <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_damage_fnc_handleCoagulationPFH;
 *
 * Public: No
 */

params ["_patient", ["_fromTXA", false]];

if (_patient getVariable [QGVAR(Coagulation_PFH), -1] != -1 || !(IS_BLEEDING(_patient))) exitWith {};

_patient setVariable [QGVAR(Coagulation_LastClotTime), CBA_missionTime];

private _id = [{
    params ["_args", "_idPFH"];
    _args params ["_patient", ["_fromTXA", false]];

    private _plateletCount = _patient getVariable [QEGVAR(circulation,Platelet_Count), 3];

    if (!(alive _patient) || ((_patient getVariable [QGVAR(Coagulation_LastClotTime), -1]) + 120 < CBA_missionTime)) exitWith {
        _patient setVariable [QGVAR(Coagulation_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _txaCount = ([_patient, "TXA_IV", false] call ACEFUNC(medical_status,getMedicationCount)) min 1.4;

    if (GET_HEART_RATE(_patient) < 20 || (_plateletCount < 0.5 && _txaCount < 0.1) || (GET_EFF_BLOOD_VOLUME(_patient) < 3.6)) exitWith {};

    private _exit = true;

    private _maximumWoundSeverity = ceil (_plateletCount / 2);

    {
        private _openWounds = GET_OPEN_WOUNDS(_patient);
        private _openWoundsOnPart = _openWounds getOrDefault [_x, []];

        if (_openWoundsOnPart isEqualTo [] || [_patient, _x] call ACEFUNC(medical_treatment,hasTourniquetAppliedTo)) then {
            continue;
        };
        
        private _woundIndex = _openWoundsOnPart findIf {(_x select 1) > 0 && (_x select 2) > 0 && (((_x select 0) % 10) + 1) <= _maximumWoundSeverity};

        if (_woundIndex != -1) exitWith {
            [_patient, _x, 2, _maximumWoundSeverity] call FUNC(clotWoundsOnBodyPart);
            _patient setVariable [QGVAR(Coagulation_LastClotTime), CBA_missionTime];
            _exit = false;
        };
    } forEach ALL_BODY_PARTS_PRIORITY;

    if (_exit) exitWith {
        _patient setVariable [QGVAR(Coagulation_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
}, 6.5, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Coagulation_PFH), _id];