#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient entering critical vitals (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_handleCriticalVitals;
 *
 * Public: No
 */

params ["_patient"];

if ((_patient getVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_Sinus]) == ACM_Rhythm_Asystole) exitWith {};

private _gracePeriod = 15 + (random 15);

_patient setVariable [QGVAR(CriticalVitals_Time), (CBA_missionTime + _gracePeriod)];
_patient setVariable [QGVAR(CriticalVitals_State), true, true];

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _currentRhythm = _patient getVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_Sinus];
    private _HR = GET_HEART_RATE(_patient);

    ([_patient] call ACEFUNC(medical_status,getBloodPressure)) params ["_BPDiastolic", "_BPSystolic"];

    private _MAP = GET_MAP(_BPSystolic,_BPDiastolic);
    
    private _timeUntil = _patient getVariable [QGVAR(CriticalVitals_Time), -1];

    private _heartRateLimits = _HR > 240 || _HR < 30;
    private _pressureLimits = _MAP > 200 || _MAP < 55;

    if (_HR > 245 || _HR < 10 || _MAP > 220 || _MAP < 30 || ((_heartRateLimits || _pressureLimits) && CBA_missionTime > (_timeUntil + 15)) || !(alive _patient) || IN_CRDC_ARRST(_patient) || !(_currentRhythm in [ACM_Rhythm_Sinus, ACM_Rhythm_VT])) exitWith {
        if (alive _patient) then {
            if !(GET_CIRCULATIONSTATE(_patient)) then {
                _patient setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_PEA];
            } else {
                if (_HR > 200) then {
                    _patient setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_PVT];
                } else {
                    _patient setVariable [QEGVAR(circulation,CardiacArrest_TargetRhythm), ACM_Rhythm_VF];
                };
            };


            if !(IN_CRDC_ARRST(_patient)) then {
                [QACEGVAR(medical,FatalVitals), _patient] call CBA_fnc_localEvent;
            };

            _patient setVariable [QGVAR(CriticalVitals_Passed), true, true];

            [{
                params ["_patient", "_time"];

                !(IN_CRITICAL_STATE(_patient)) && !(IN_CRDC_ARRST(_patient)) && _time < CBA_missionTime;
            }, {
                params ["_patient"];

                if (alive _patient && (_patient getVariable [QGVAR(CriticalVitals_Passed), false])) then {
                    _patient setVariable [QGVAR(CriticalVitals_Passed), false, true];
                };
            }, [_patient, (CBA_missionTime + (15 + (random 15)))], 3600] call CBA_fnc_waitUntilAndExecute;
        };

        _patient setVariable [QGVAR(CriticalVitals_State), false, true];
        _patient setVariable [QGVAR(CriticalVitals_PFH), -1];

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (!(IN_CRDC_ARRST(_patient)) && {_HR > 45 && _HR < 200 && _MAP > 60 && _MAP < 180}) exitWith {
        if (_currentRhythm == ACM_Rhythm_VT) then {
            _patient setVariable [QEGVAR(circulation,Cardiac_RhythmState), ACM_Rhythm_Sinus, true];
        };

        _patient setVariable [QGVAR(CriticalVitals_State), false, true];
        _patient setVariable [QGVAR(CriticalVitals_PFH), -1];

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (!(IS_UNCONSCIOUS(_patient)) && {_heartRateLimits || _pressureLimits || CBA_missionTime > _timeUntil}) then {
        [QACEGVAR(medical,CriticalVitals), _patient] call CBA_fnc_localEvent;
    };
}, 1, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(CriticalVitals_PFH), _PFH];