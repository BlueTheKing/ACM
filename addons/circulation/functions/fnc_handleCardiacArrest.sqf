#include "..\script_component.hpp"
/*
 * Author: Blue
 * Assign cardiac arrest rhythm to patient and begin PFH (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_handleCardiacArrest;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(CardiacArrest_RhythmState), -1] == ACM_Rhythm_Asystole) exitWith {};

/*
    0 - Sinus
    1 - Asystole
    2 - Ventricular Fibrillation
    3 - (Pulseless) Ventricular Tachycardia
    4 - Ventricular Tachycardia (?)
    5 - Pulseless Electrical Activity (Reversible)
*/

if (_patient getVariable [QGVAR(CardiacArrest_PFH), -1] != -1) exitWith {};

_patient setVariable [QGVAR(CardiacArrest_DeteriorationTime), CBA_missionTime];

if (GET_BLOOD_VOLUME(_patient) < ACM_Rhythm_Asystole_BLOODVOLUME) exitWith {
    _patient setVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Asystole, true]; // asystole
};

private _targetRhythm = _patient getVariable [QGVAR(CardiacArrest_TargetRhythm), ACM_Rhythm_Sinus];

if (_targetRhythm == ACM_Rhythm_Sinus) then {
    _targetRhythm = [ACM_Rhythm_VF,ACM_Rhythm_PVT] select (((random 100) * (GET_BLOOD_VOLUME(_patient) / BLOOD_VOLUME_CLASS_2_HEMORRHAGE)) > 50);
};
_patient setVariable [QGVAR(CardiacArrest_RhythmState), _targetRhythm, true];
_patient setVariable [QGVAR(CardiacArrest_TargetRhythm), ACM_Rhythm_Sinus];

if !(alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull])) then {
    _patient setVariable [QGVAR(CPR_StoppedTime), CBA_missionTime, true];
};

private _deteriorateInterval = 10 + (random 8);

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient", "_deteriorateInterval"];

    private _currentRhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Sinus];

    if (!(alive _patient) || !(IN_CRDC_ARRST(_patient)) || _currentRhythm in [ACM_Rhythm_Asystole,ACM_Rhythm_PEA]) exitWith {
        _patient setVariable [QGVAR(CardiacArrest_PFH), -1];

        if !(alive _patient) then {
            _patient setVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Asystole, true];
        };

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _noCPRTime = ((_patient getVariable [QGVAR(CPR_StoppedTime), 0]) - CBA_missionTime) max 0;
    private _CPREffect = (((_patient getVariable [QGVAR(CPR_StoppedTotal), 0]) / 120) min 1);

    if (alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull]) || {_noCPRTime < (45 * _CPREffect)}) exitWith {};

    private _cardiacArrestTime = (_patient getVariable [QGVAR(CardiacArrest_DeteriorationTime), -1]) - CBA_missionTime;

    if (((random 1) < (0.4 * GVAR(cardiacArrestDeteriorationRate))) && {_cardiacArrestTime > (30 + random(30))}) then {
        private _targetRhythm = (_currentRhythm - 1) max 1;

        _patient setVariable [QGVAR(CardiacArrest_RhythmState), _targetRhythm, true];
        _patient setVariable [QGVAR(CardiacArrest_DeteriorationTime), CBA_missionTime];
    };
}, _deteriorateInterval, [_patient, _deteriorateInterval]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(CardiacArrest_PFH), _PFH];

// Handle deteriorating into asystole due to bloodloss
[{
    params ["_patient"];

    (GET_BLOOD_VOLUME(_patient) < ACM_Rhythm_Asystole_BLOODVOLUME) || !(alive _patient) || !(IN_CRDC_ARRST(_patient))
}, {
    params ["_patient"];

    if (alive _patient && (GET_BLOOD_VOLUME(_patient) < ACM_Rhythm_Asystole_BLOODVOLUME)) then {
        _patient setVariable [QGVAR(CardiacArrest_RhythmState), ACM_Rhythm_Asystole, true];
    };
}, [_patient], 3600] call CBA_fnc_waitUntilAndExecute;