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

    private _rhythmState = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];

    if (!(IN_CRDC_ARRST(_patient)) || _rhythmState == 5 || !(alive _patient)) exitWith {};

    private _bloodVolume = GET_BLOOD_VOLUME(_patient);

    if (_bloodVolume < BLOOD_VOLUME_CLASS_4_HEMORRHAGE) exitWith {};

    private _medicSkill = switch (true) do {
        case ([_medic, 2] call ACEFUNC(medical_treatment,isMedic)): {65}; // Doctor
        case ([_medic, 1] call ACEFUNC(medical_treatment,isMedic)): {45}; // Medic
        default {25}; // Other
    };

    private _consistencyEffect = ((CBA_missionTime - _CPRStartTime) / 120) min 2;
    private _bloodlossEffect = linearConversion [BLOOD_VOLUME_CLASS_4_HEMORRHAGE, BLOOD_VOLUME_CLASS_2_HEMORRHAGE, _bloodVolume, 0, 1, true];

    private _shockEffect = ((120 / (CBA_missionTime - (_patient getVariable [QGVAR(AED_LastShock), -1]))) min 2) max 0.8;
    private _rhythmEffect = 1;
    private _medicationEffect = 1;

    private _cardiacMedication = [_patient] call FUNC(getCardiacMedicationEffects);

    private _epinephrine = _cardiacMedication get "epinephrine";
    private _morphine = _cardiacMedication get "morphine";
    private _amiodarone = _cardiacMedication get "amiodarone";
    
    switch (_rhythmState) do {
        case 3: {
            _rhythmEffect = _shockEffect;
            _medicationEffect = (1 max (_epinephrine + _amiodarone min 2.2)) - _morphine;
        };
        case 2: {
            _rhythmEffect = 0.9 * _shockEffect;
            _medicationEffect = (1 max (_epinephrine + _amiodarone min 2.2)) - _morphine;
        };
        case 1: {
            _rhythmEffect = 0.8;
            _medicationEffect = (1 max _epinephrine) - _morphine;
        };
    };

    if (random 100 < (_medicSkill * GVAR(CPREffectiveness) * _bloodlossEffect * _consistencyEffect * _rhythmEffect * _medicationEffect)) then {
        if (_rhythmState == 1) then {
            private _newRhythm = [2,3] select (random 1 < 0.5);

            _patient setVariable [QGVAR(CardiacArrest_RhythmState), _newRhythm, true];
        } else {
            [QGVAR(attemptROSC), _patient] call CBA_fnc_localEvent;
        };
    };
}, 5, [_patient, _CPRStartTime]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(CPR_PFH), _PFH];