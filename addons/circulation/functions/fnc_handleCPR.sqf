#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle CPR being performed on patient
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: CPR Start Time <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, CBA_missionTime] call AMS_circulation_fnc_handleCPR;
 *
 * Public: No
 */

params ["_patient", "_CPRStartTime"];

if (_patient getVariable [QGVAR(CPR_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient", "_CPRStartTime"];

    private _medic = _patient getVariable [QACEGVAR(medical,CPR_provider), objNull]

    if !(alive _medic) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if !(IN_CRDC_ARRST(_patient)) exitWith {};

    private _bloodVolume = GET_BLOOD_VOLUME(_patient);

    if !(_bloodVolume < BLOOD_VOLUME_CLASS_4_HEMORRHAGE) exitWith {};

    private _medicSkill = switch (true) do {
        case ([_medic, 2] call ACEFUNC(medical_treatment,isMedic)): {120}; // Doctor
        case ([_medic, 1] call ACEFUNC(medical_treatment,isMedic)): {110}; // Medic
        default {100}; // Other
    };

    private _consistencyEffect = ((CBA_missionTime - _CPRStartTime) / 120) min 1;
    private _bloodlossEffect = linearConversion [BLOOD_VOLUME_CLASS_4_HEMORRHAGE, BLOOD_VOLUME_CLASS_2_HEMORRHAGE, _bloodVolume, 0, 1, true];

    private _shockEffect = ((45 / (CBA_missionTime - (_patient getVariable [QGVAR(AEDMonitor_LastShock), -1]))) min 2);

    private _rhythmState = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];
    private _rhythmEffect = 1;

    private _medicationEffect = 1;

    private _morphine = ([_patient, "Morphine", false] call ACEFUNC(medical_status,getMedicationCount) * 0.3) min 0.5;
    private _morphineVial = ([_patient, "Morphine_Vial", false] call ACEFUNC(medical_status,getMedicationCount) * 0.6) min 0.8; // TODO simplify this, get everything with single function ie less forEaching to get multiple things
    private _epinephrine = ([_patient, "Epinephrine", false] call ACEFUNC(medical_status,getMedicationCount) * 1.3) min 1.6;
    private _epinephrineVial = ([_patient, "Epinephrine_Vial", false] call ACEFUNC(medical_status,getMedicationCount) * 1.5) min 1.8;
    private _amiodaroneVial = ([_patient, "Amiodarone_Vial", false] call ACEFUNC(medical_status,getMedicationCount) * 2) min 2;

    _epinephrine = _epinephrine max _epinephrineVial;
    _morphine = _morphine max _morphineVial;
    
    switch (_rhythmState) do {
        case 3: {
            _rhythmEffect = _shockEffect;
            _medicationEffect = (_epinephrine + _amiodaroneVial min 2.2) - _morphine;
        };
        case 2: {
            _rhythmEffect = 0.9 * _shockEffect;
            _medicationEffect = (_epinephrine + _amiodaroneVial min 2.2) - _morphine;
        };
        case 1: {
            _rhythmEffect = 0.8
            _medicationEffect = _epinephrine - _morphine;
        };
    };
    ;
    
    if (random 100 < (_medicSkill * _bloodlossEffect * _consistencyEffect * _rhythmEffect * _medicationEffect)) then {
        [QEGVAR(medical,CPRSucceeded), _patient] call CBA_fnc_localEvent;
    };
}, 5, [_patient, _CPRStartTime]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(CPR_PFH), _PFH];