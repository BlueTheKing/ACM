#include "..\script_component.hpp"
/*
 * Author: Blue
 * Begin analyze rhythm process for AED
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, false] call AMS_circulation_fnc_AED_AnalyzeRhythm;
 *
 * Public: No
 */

params ["_medic", "_patient"];

_patient setVariable [QGVAR(AED_AnalyzeRhythm_State), false, true];

_patient setVariable [QGVAR(AED_InUse), true, true];
_medic setVariable [QGVAR(AED_Medic_InUse), true, true];

private _timeToAnalyze = (4 + (random 4)) + 4 * (1 - (GET_BLOOD_VOLUME(_patient) / 7));

playSound3D [QPATHTO_R(sound\aed_analyzingnow.wav), _patient, false, getPosASL _patient, 15, 1, 12]; // 3.074s

[{
    params ["_patient", "_medic"];

    _patient setVariable [QGVAR(AED_AnalyzeRhythm_State), true, true];

    private _shockable = (_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0]) in [2,3];
    private _adviceDelay = 2;

    if (_shockable) then {
        playSound3D [QPATHTO_R(sound\aed_shockadvised.wav), _patient, false, getPosASL _patient, 15, 1, 12]; // 1.662s
        _adviceDelay = 1.7;
    } else {
        playSound3D [QPATHTO_R(sound\aed_noshockadvised.wav), _patient, false, getPosASL _patient, 15, 1, 12]; // 1.99s
    };

    [{
        params ["_patient", "_medic", "_shockable"];

        if (_shockable) then {
            [_medic, _patient] call FUNC(AED_BeginCharge);
        } else {
            _patient setVariable [QGVAR(AED_InUse), false, true];
            _medic setVariable [QGVAR(AED_Medic_InUse), false, true];

            playSound3D [QPATHTO_R(sound\aed_startcpr.wav), _patient, false, getPosASL _patient, 15, 1, 12]; // 1.858s
        };

    }, [_patient, _medic, _shockable], 2] call CBA_fnc_waitAndExecute;
}, [_patient, _medic], _timeToAnalyze] call CBA_fnc_waitAndExecute;