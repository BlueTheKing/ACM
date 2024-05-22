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
 * [player, cursorTarget, false] call ACM_circulation_fnc_AED_AnalyzeRhythm;
 *
 * Public: No
 */

params ["_medic", "_patient"];

_patient setVariable [QGVAR(AED_AnalyzeRhythm_State), false, true];

_patient setVariable [QGVAR(AED_InUse), true, true];
_medic setVariable [QGVAR(AED_Medic_InUse), true, true];

private _timeToAnalyze = (4 + (random 4)) + 4 * (1 - (GET_BLOOD_VOLUME(_patient) / 7));

playSound3D [QPATHTO_R(sound\aed_analyzingnow.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 3.074s

_patient setVariable [QGVAR(AED_Analyze_Busy), true, true];

[{
    params ["_medic", "_patient"];

    !([_patient, "", 1] call FUNC(hasAED));
}, {
    params ["_medic", "_patient"];

    playSound3D [QPATHTO_R(sound\aed_3beep.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.624s
}, [_medic, _patient], _timeToAnalyze, 
{
    params ["_medic", "_patient"];

    _patient setVariable [QGVAR(AED_AnalyzeRhythm_State), true, true];

    private _shockable = (_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0]) in [2,3];
    private _adviceDelay = 2;

    if (_shockable) then {
        playSound3D [QPATHTO_R(sound\aed_shockadvised.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 1.662s
        _adviceDelay = 1.7;
    } else {
        playSound3D [QPATHTO_R(sound\aed_noshockadvised.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 1.99s
    };

    [{
        params ["_patient", "_medic", "_shockable"];

        if (_shockable) then {
            [_medic, _patient] call FUNC(AED_BeginCharge);
        } else {
            _patient setVariable [QGVAR(AED_InUse), false, true];
            _medic setVariable [QGVAR(AED_Medic_InUse), false, true];

            [_patient] call FUNC(AED_TrackCPR);
            playSound3D [QPATHTO_R(sound\aed_startcpr.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 1.858s
            
            [{
                params ["_patient", "_medic"];
                
                _patient setVariable [QGVAR(AED_Analyze_Busy), false, true];
            }, [_patient, _medic], 2] call CBA_fnc_waitAndExecute;
        };

    }, [_patient, _medic, _shockable], _adviceDelay] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_waitUntilAndExecute;