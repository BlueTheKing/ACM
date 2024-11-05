#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle adenosine effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_handleMed_AdenosineLocal;
 *
 * Public: No
 */

params ["_patient"];

private _targetRhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Sinus];

if (!(alive _patient) || _targetRhythm == ACM_Rhythm_Asystole) exitWith {};

[{
    params ["_patient"];

    !(alive _patient) || ((_patient getVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Sinus]) == ACM_Rhythm_Asystole) || ([_patient, "Adenosine_IV", false] call ACEFUNC(medical_status,getMedicationCount) > 0.9);
}, {
    params ["_patient", "_targetRhythm"];

    if (!(alive _patient) || (_patient getVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Sinus]) == ACM_Rhythm_Asystole) exitWith {};

    if !(IN_CRDC_ARRST(_patient)) then {
        _patient setVariable [QGVAR(CardiacArrest_TargetRhythm), ACM_Rhythm_Asystole];
        [QACEGVAR(medical,FatalVitals), _patient] call CBA_fnc_localEvent;
    };

    [{
        params ["_patient"];

        !(alive _patient) || ([_patient, "Adenosine_IV", false] call ACEFUNC(medical_status,getMedicationCount) < 0.5);
    }, {
        params ["_patient", "_targetRhythm"];

        if (!(alive _patient) || (_patient getVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Sinus]) != ACM_Rhythm_Asystole) exitWith {};

        if (_targetRhythm == ACM_Rhythm_Sinus) exitWith {
            [QGVAR(attemptROSC), _patient] call CBA_fnc_localEvent;
        };

        _patient setVariable [QGVAR(CardiacArrest_RhythmState), _targetRhythm, true];
    }, [_patient, _targetRhythm], 180] call CBA_fnc_waitUntilAndExecute;
}, [_patient, _targetRhythm], 60] call CBA_fnc_waitUntilAndExecute;