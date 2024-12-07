#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle CPR being performed on patient (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: CPR Start Time <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, CBA_missionTime] call ACM_circulation_fnc_handleCPR;
 *
 * Public: No
 */

params ["_patient", "_CPRStartTime"];

if (_patient getVariable [QGVAR(CPR_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient", "_CPRStartTime"];

    private _medic = _patient getVariable [QACEGVAR(medical,CPR_provider), objNull];

    if !(alive _medic) exitWith {
        _patient setVariable [QGVAR(CPR_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _rhythmState = _patient getVariable [QGVAR(Cardiac_RhythmState), ACM_Rhythm_Sinus];

    if (!(IN_CRDC_ARRST(_patient)) || _rhythmState == ACM_Rhythm_PEA || !(alive _patient)) exitWith {};

    private _bloodVolume = GET_BLOOD_VOLUME(_patient);

    if (_bloodVolume < BLOOD_VOLUME_CLASS_4_HEMORRHAGE) exitWith {};

    private _medicSkill = switch (true) do {
        case ([_medic, 2] call ACEFUNC(medical_treatment,isMedic)): {0.65}; // Doctor
        case ([_medic, 1] call ACEFUNC(medical_treatment,isMedic)): {0.45}; // Medic
        default {0.25}; // Other
    };

    private _lastCPRTime = _patient getVariable [QGVAR(CPR_StoppedTotal), 0];
    private _lastCPRStoppedTime = _patient getVariable [QGVAR(CPR_StoppedTime), 0];

    private _lastConsistencyEffect = 1.2 min ((_lastCPRTime / 120) * (((CBA_missionTime - _lastCPRStoppedTime) / 60))) max 1;
    private _consistencyEffect = _lastConsistencyEffect * (((CBA_missionTime - _CPRStartTime) / 120) min 2);
    private _bloodlossEffect = linearConversion [BLOOD_VOLUME_CLASS_4_HEMORRHAGE, BLOOD_VOLUME_CLASS_2_HEMORRHAGE, _bloodVolume, 0, 1, true];

    private _shockEffect = ((120 / (CBA_missionTime - (_patient getVariable [QGVAR(AED_LastShock), -120]))) min 1.7) max 0.8;
    private _rhythmEffect = 1;
    private _medicationEffect = 1;

    private _cardiacMedication = [_patient] call FUNC(getCardiacMedicationEffects);

    private _epinephrine = _cardiacMedication get "epinephrine";
    private _morphine = _cardiacMedication get "morphine";
    private _fentanyl = _cardiacMedication get "fentanyl";
    private _amiodarone = _cardiacMedication get "amiodarone";
    private _lidocaine = _cardiacMedication get "lidocaine";
    
    switch (_rhythmState) do {
        case ACM_Rhythm_PVT: {
            _rhythmEffect = 0.9 * _shockEffect;
            _medicationEffect = ((1 max ((_epinephrine + _amiodarone + _lidocaine) min 2.2)) - _morphine) - _fentanyl;
        };
        case ACM_Rhythm_VF: {
            _rhythmEffect = 0.85 * _shockEffect;
            _medicationEffect = ((1 max ((_epinephrine + _amiodarone + _lidocaine) min 2.2)) - _morphine) - _fentanyl;
        };
        case ACM_Rhythm_Asystole: {
            _rhythmEffect = 1.2;
            _medicationEffect = ((1 max _epinephrine) - _morphine) - _fentanyl;
        };
    };

    private _chance = _medicSkill * GVAR(CPREffectiveness) * _bloodlossEffect * _consistencyEffect * _rhythmEffect * _medicationEffect;

    if (_chance > 0.1 && {random 1 < _chance}) then {
        if (_rhythmState == 1) then {
            private _newRhythm = [ACM_Rhythm_VF,ACM_Rhythm_PVT] select (random 1 < 0.5);

            _patient setVariable [QGVAR(Cardiac_RhythmState), _newRhythm, true];
        } else {
            [QGVAR(attemptROSC), _patient] call CBA_fnc_localEvent;
        };
    };
}, 5, [_patient, _CPRStartTime]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(CPR_PFH), _PFH];