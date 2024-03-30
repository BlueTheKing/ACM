#include "..\script_component.hpp"
/*
 * Author: Blue
 * Begin analyze rhythm process for AED
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Is medic in monitor view <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, false] call AMS_circulation_fnc_AED_AnalyzeRhythm;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_inMonitor", false]];

_patient setVariable [QGVAR(AEDMonitor_AnalyzeRhythm_State), false, true];

_patient setVariable [QGVAR(AEDMonitor_InUse), true, true];
_medic setVariable [QGVAR(AEDMonitor_Medic_InUse), true, true];

private _timeToAnalyze = (4 + (random 4)) + 4 * (1 - (GET_BLOOD_VOLUME(_patient) / 7));

//playSound3D [QPATHTO_R(sound\aed_analyzingnow.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 3.074s

if (_inMonitor) then {
    //playSoundUI [QPATHTO_R(sound\aed_analyzingnow.wav), 0.5, 1, true]; // TODO move to event
};

[{
    params ["_patient", "_medic"];

    _patient setVariable [QGVAR(AEDMonitor_AnalyzeRhythm_State), true, true];

    private _shockable = (_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0]) in [2,3];
    private _adviceDelay = 1.9;

    if (_shockable) then {
        //playSound3D [QPATHTO_R(sound\aed_shockadvised.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 1.662s
        _adviceDelay = 1.7;
    } else {
        //playSound3D [QPATHTO_R(sound\aed_noshockadvised.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 1.812s
    };

    [{
        params ["_patient", "_medic", "_shockable"];

        if (_shockable) then {
            [_medic, _patient] call FUNC(AED_BeginCharge);
        } else {
            _patient setVariable [QGVAR(AEDMonitor_InUse), false, true];
            _medic setVariable [QGVAR(AEDMonitor_Medic_InUse), false, true];
        };

    }, [_patient, _medic, _shockable], 2] call CBA_fnc_waitAndExecute;
}, [_patient, _medic], _timeToAnalyze] call CBA_fnc_waitAndExecute;