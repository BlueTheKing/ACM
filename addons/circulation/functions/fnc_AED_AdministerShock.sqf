#include "..\script_component.hpp"
/*
 * Author: Blue
 * Administer defibrillator shock
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Is in manual mode <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, false] call AMS_circulation_fnc_AED_AdministerShock;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_manual", false]];

//playSound3D [QPATHTO_R(sound\aed_shock.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 0.1s idk lol

_patient setVariable [QGVAR(AEDMonitor_Charged), false, true];
_patient setVariable [QGVAR(AEDMonitor_InUse), false, true];
_medic setVariable [QGVAR(AEDMonitor_Medic_InUse), false, true];

_patient setVariable [QGVAR(AEDMonitor_LastShock), CBA_missionTime];

if !(_manual) then { 
    [{ // Reminder to re-analyze
        params ["_patient", "_medic"];

        //playSound3D [QPATHTO_R(sound\aed_checkpulse_pushtoanalyze.wav), _patient, false, getPosASL _patient, 1, 1, 3]; // 0.1s

    }, [_patient, _medic], 5] call CBA_fnc_waitAndExecute;
};

if (_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0] in [1,5]) exitWith {
    _patient setVariable [QGVAR(CardiacArrest_RhythmState), 1, true];
};

private _amiodaroneVial = ([_patient, "Amiodarone_Vial", false] call ACEFUNC(medical_status,getMedicationCount) * 2) min 2; // TODO move to function

if (random 100 < (2 + (2 * _amiodaroneVial))) exitWith { // ROSC
    [QEGVAR(medical,CPRSucceeded), _patient] call CBA_fnc_localEvent;
    _patient setVariable [QGVAR(CardiacArrest_RhythmState), 0];
};