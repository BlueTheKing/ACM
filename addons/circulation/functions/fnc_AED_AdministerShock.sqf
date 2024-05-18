#include "..\script_component.hpp"
/*
 * Author: Blue
 * Administer defibrillator shock
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_circulation_fnc_AED_AdministerShock;
 *
 * Public: No
 */

params ["_medic", "_patient"];

//playSound3D [QPATHTO_R(sound\aed_shock.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.1s

_patient setVariable [QGVAR(AED_Charged), false, true];
_patient setVariable [QGVAR(AED_InUse), false, true];
_medic setVariable [QGVAR(AED_Medic_InUse), false, true];

_patient setVariable [QGVAR(AED_LastShock), CBA_missionTime, true];

private _totalShocks = _patient getVariable [QGVAR(AED_ShockTotal), 0];
_patient setVariable [QGVAR(AED_ShockTotal), (_totalShocks + 1), true];

if (_patient getVariable [QGVAR(AED_AnalyzeRhythm_State), false]) then { // AED Mode
    [{ // Reminder to start CPR
        params ["_patient", "_medic"];

        [_patient] call FUNC(AED_TrackCPR);
        playSound3D [QPATHTO_R(sound\aed_startcpr.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 1.858s

    }, [_patient, _medic], 2] call CBA_fnc_waitAndExecute;

    _patient setVariable [QGVAR(AED_Analyze_Busy), true, true];

    [{ // Stay quiet to hear advice
        params ["_patient", "_medic"];

        _patient setVariable [QGVAR(AED_Analyze_Busy), false, true];

    }, [_patient, _medic], 4] call CBA_fnc_waitAndExecute;
    _patient setVariable [QGVAR(AED_AnalyzeRhythm_State), false, true];
} else {
    [{
        params ["_patient", "_medic"];

        playSound3D [QPATHTO_R(sound\aed_3beep.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.624s

    }, [_patient, _medic], 0.7] call CBA_fnc_waitAndExecute;
};

if !(alive _patient) exitWith {};

private _currentRhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];

if (_currentRhythm in [0,1,5]) exitWith {
    _patient setVariable [QGVAR(CardiacArrest_RhythmState), 1, true];
    if (_currentRhythm == 0) then {
        [QACEGVAR(medical,FatalVitals), [_patient], _patient] call CBA_fnc_targetEvent;
    };
};

private _amiodarone = ([_patient] call FUNC(getCardiacMedicationEffects)) get "amiodarone";

private _CPREffectiveness = 0;

private _CPRAmount = _patient getVariable [QGVAR(CPR_StoppedTotal), 0];
if (_CPRAmount > 60) then {
    _CPREffectiveness = linearConversion [60, 120, _CPRAmount, 0, 10, false];
};

if (random 100 < (_CPREffectiveness + (10 + (10 * _amiodarone)))) exitWith { // ROSC
    [QGVAR(attemptROSC), [_patient], _patient] call CBA_fnc_targetEvent;
};