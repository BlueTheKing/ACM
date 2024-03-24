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
 * [player] call AMS_circulation_fnc_handleCardiacArrest;
 *
 * Public: No
 */

params ["_patient"];

/*
    0 - Sinus
    1 - Asystole
    2 - Ventricular Fibrillation
    3 - (Pulseless) Ventricular Tachycardia
    4 - Ventricular Tachycardia (?)
    5 - Pulseless Electrical Activity (Reversible)
*/

if (_patient getVariable [QGVAR(CardiacArrest_PFH), -1] != -1) exitWith {};

_patient setVariable [QGVAR(CardiacArrest_Time), CBA_missionTime];

if (GET_BLOOD_VOLUME(_patient) < 3.2) exitWith {
    _patient setVariable [QGVAR(CardiacArrest_RhythmState), 1, true]; // asystole
};

private _targetRhythm = [2,3] select (((random 100) * (GET_BLOOD_VOLUME(_patient) / BLOOD_VOLUME_CLASS_2_HEMORRHAGE)) > 50);
_patient setVariable [QGVAR(CardiacArrest_RhythmState), _targetRhythm, true];

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _currentRhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];

    if (!(IN_CRDC_ARRST(_patient)) || _currentRhythm in [1,5]) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (alive (_unit getVariable [QACEGVAR(medical,CPR_provider), objNull])) exitWith {
        _patient setVariable [QGVAR(CardiacArrest_Time), (CBA_missionTime - (random 5))];
    };

    private _cardiacArrestTime = _patient getVariable [QGVAR(CardiacArrest_Time), -1];

    if (((random 100) < 40) && {_cardiacArrestTime > (_cardiacArrestTime + (60 + random(30)))}) then { // TODO settings
        private _targetRhythm = (_currentRhythm - 1) max 1;

        _patient setVariable [QGVAR(CardiacArrest_RhythmState), _targetRhythm, true];
        _patient setVariable [QGVAR(CardiacArrest_Time), CBA_missionTime];
    };
}, (10 + (random 8)), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(CardiacArrest_PFH), _PFH];

// Handle deteriorating into asystole due to bloodloss
[{
    params ["_patient"];

    (GET_BLOOD_VOLUME(_patient) < 3.2) || !(alive _patient) || !(IN_CRDC_ARRST(_patient))
}, {
    params ["_patient"];

    if (alive _patient && (GET_BLOOD_VOLUME(_patient) < 3.2)) then {
        _patient setVariable [QGVAR(CardiacArrest_RhythmState), 1, true];
    };
}, [_patient], 3600] call CBA_fnc_waitUntilAndExecute;