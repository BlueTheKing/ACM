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

_patient setVariable [QGVAR(Coagulation_Active), true, true];

_patient setVariable [QGVAR(Coagulation_LastClotTime), CBA_missionTime];
_patient setVariable [QGVAR(Coagulation_NextAttempt), (CBA_missionTime + (9 + random 5))];

private _id = [{
    params ["_args", "_idPFH"];
    _args params ["_patient", ["_fromTXA", false]];

    private _plateletCount = _patient getVariable [QEGVAR(circulation,Platelet_Count), 3];

    if (!(alive _patient) || ((_patient getVariable [QGVAR(Coagulation_LastClotTime), -1]) + 120 < CBA_missionTime)) exitWith {
        _patient setVariable [QGVAR(Coagulation_PFH), -1];
        _patient setVariable [QGVAR(Coagulation_Active), false, true];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _txaCount = ([_patient, "TXA_IV", false] call ACEFUNC(medical_status,getMedicationCount)) min 2;

    if ((_patient getVariable [QGVAR(Coagulation_NextAttempt), 0]) > CBA_missionTime) exitWith {};

    _patient setVariable [QGVAR(Coagulation_NextAttempt), (CBA_missionTime + 12 - ((_txaCount * 3) + _plateletCount))];

    if (GET_HEART_RATE(_patient) < 20 || (_plateletCount < 1 && _txaCount < 0.5) || (GET_EFF_BLOOD_VOLUME(_patient) < 3.8)) exitWith {};

    private _exit = true;

    private _maximumWoundSeverity = (ceil (_plateletCount / 2)) max (ceil _txaCount);

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
        _patient setVariable [QGVAR(Coagulation_Active), false, true];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
}, 1, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Coagulation_PFH), _id];