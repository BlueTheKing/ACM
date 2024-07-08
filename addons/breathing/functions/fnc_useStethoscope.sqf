#include "..\script_component.hpp"
#include "..\Stethoscope_defines.hpp"
/*
 * Author: Blue
 * Handle using stethoscope on chest.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_useStethoscope;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[_patient, "activity", "%1 inspected chest with Stethoscope", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[[_medic, _patient, _bodyPart], { // On Start
    params ["_medic", "_patient", "_bodyPart"];

    GVAR(Stethoscope_BellMoving) = false;
    GVAR(Stethoscope_NextBreath) = -1;
    GVAR(Stethoscope_NextBeat) = -1;

    GVAR(Stethoscope_BreathSoundID) = -1;
    GVAR(Stethoscope_BeatSoundID) = -1;

    ACEGVAR(hearing,volumeAttenuation) = 0.2;
    [ACELLSTRING(Volume,Lowered), 1.5, _medic] call ACEFUNC(common,displayTextStructured);

    createDialog QGVAR(Stethoscope_Dialog);

    uiNamespace setVariable [QGVAR(Stethoscope_DLG),(findDisplay IDC_STETHOSCOPE)];

    private _display = uiNamespace getVariable [QGVAR(Stethoscope_DLG), displayNull];
    private _ctrlText = _display displayCtrl IDC_STETHOSCOPE_TEXT; 
    _ctrlText ctrlSetText format ["%1 (Torso)", [_patient, false, true] call ACEFUNC(common,getName)];
}, { // On cancel
    params ["_medic", "_patient", "_bodyPart", "", "_notInVehicle"];

    stopSound GVAR(Stethoscope_BreathSoundID);
    stopSound GVAR(Stethoscope_BeatSoundID);

    if !(isNull findDisplay IDC_STETHOSCOPE) then {
        closeDialog 0;
    };

    if (_notInVehicle) then {
        [_medic, "AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation);
    };

    ["Stopped using stethoscope", 1.5, _medic] call ACEFUNC(common,displayTextStructured);

    call ACEFUNC(hearing,updateHearingProtection);
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart"];

    private _display = uiNamespace getVariable [QGVAR(Stethoscope_DLG), displayNull];
    private _ctrlBell = _display displayCtrl IDC_STETHOSCOPE_BELL;
    private _ctrlBellCenter = [(((ctrlPosition _ctrlBell) select 0) + (((ctrlPosition _ctrlBell) select 2) / 2)), (((ctrlPosition _ctrlBell) select 1) + (((ctrlPosition _ctrlBell) select 3) / 2))];

    private _ctrlLeftLung = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_LEFTLUNG);
    private _ctrlLeftLungCenter = [((_ctrlLeftLung select 0) + ((_ctrlLeftLung select 2) / 2)), ((_ctrlLeftLung select 1) + ((_ctrlLeftLung select 3) / 2))];
    private _ctrlRightLung = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_RIGHTLUNG);
    private _ctrlRightLungCenter = [((_ctrlRightLung select 0) + ((_ctrlRightLung select 2) / 2)), ((_ctrlRightLung select 1) + ((_ctrlRightLung select 3) / 2))];
    private _ctrlHeart = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_HEART);
    private _ctrlHeartCenter = [((_ctrlHeart select 0) + ((_ctrlHeart select 2) / 2)), ((_ctrlHeart select 1) + ((_ctrlHeart select 3) / 2))];

    private _rightLungDistance = (_ctrlRightLungCenter distance2D _ctrlBellCenter);
    
    private _rightLungCondition = [_ctrlRightLung, _ctrlBellCenter] call EFUNC(GUI,inZone);
    private _leftLungDistance = (_ctrlLeftLungCenter distance2D _ctrlBellCenter);
    
    private _leftLungCondition = [_ctrlLeftLung, _ctrlBellCenter] call EFUNC(GUI,inZone);

    private _heartDistance = (_ctrlHeartCenter distance2D _ctrlBellCenter);
    private _heartCondition = [_ctrlHeart, _ctrlBellCenter] call EFUNC(GUI,inZone);

    private _ctrlClavicle = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_CLAVICLE);
    private _clavicleCondition = [_ctrlClavicle, _ctrlBellCenter] call EFUNC(GUI,inZone);

    if (GVAR(Stethoscope_BellMoving)) then {
        getMousePosition params ["_mouseX", "_mouseY"];

        (ctrlPosition _ctrlBell) params ["","","_bellW","_bellH"];

        _ctrlBell ctrlSetTooltip "Place me";
        
        _ctrlBell ctrlSetPosition [_mouseX - (_bellW / 2), _mouseY - (_bellH / 2), _bellW, _bellH];
        _ctrlBell ctrlCommit 0;

        if (GVAR(Stethoscope_BeatSoundID) != -1) then {
            stopSound GVAR(Stethoscope_BeatSoundID);
            GVAR(Stethoscope_BeatSoundID) = -1;
        };

        if (GVAR(Stethoscope_BreathSoundID) != -1) then {
            stopSound GVAR(Stethoscope_BreathSoundID);
            GVAR(Stethoscope_BreathSoundID) = -1;
        };

        stopSound GVAR(Stethoscope_BreathSoundID);
        stopSound GVAR(Stethoscope_BeatSoundID);
    } else {
        _ctrlBell ctrlSetTooltip "Move me";

        private _HR = GET_HEART_RATE(_patient);
        private _RR = GET_RESPIRATION_RATE(_patient);

        if (_HR > 0 && alive _patient) then {
            if (GVAR(Stethoscope_NextBeat) < CBA_missionTime) then {
                private _heartBeatDelay = 60 / _HR;
                GVAR(Stethoscope_NextBeat) = CBA_missionTime + _heartBeatDelay;

                if (_clavicleCondition) exitWith {};

                private _variant = 1 + (round (random 2));
                private _rate = switch (true) do {
                    case (_heartBeatDelay < 0.5): {
                        "Fast";
                    };
                    case (_heartBeatDelay > 1.2): {
                        "Slow";
                    };
                    default {
                        "Normal";
                    };
                };

                GVAR(Stethoscope_BeatSoundID) = playSoundUI [(format ["ACM_Stethoscope_HeartBeat_%1_%2", _rate, _variant]), (linearConversion [0.36, 0.099, _heartDistance, 0.01, 1, true]), (1 + (random 0.1)), false];
            };
            if (_RR < 1) exitWith {};
            if (GVAR(Stethoscope_NextBreath) < CBA_missionTime) then {
                private _breathDelay = 60 / _RR;
                GVAR(Stethoscope_NextBreath) = CBA_missionTime + _breathDelay;

                private _selectLung = -1;
                
                if (_leftLungCondition) then {
                    _selectLung = 0;
                } else {
                    if (_rightLungCondition) then {
                        _selectLung = 1;
                    };
                };

                if (_selectLung == -1) exitWith {};

                private _volumeModifier = 1;

                private _type = switch (((_patient getVariable [QGVAR(Stethoscope_LungState), [0,0]]) select _selectLung)) do {
                    case 1: {
                        _volumeModifier = 0.8;
                        "Shallow";
                    };
                    case 2: {
                        _volumeModifier = 0.6;
                        "Dull";
                    };
                    default {
                        "Normal";
                    };
                };
                private _rate = switch (true) do {
                    case (_breathDelay < 2): {
                        "Fast";
                    };
                    case (_breathDelay > 5): {
                        "Slow";
                    };
                    default {
                        "Normal";
                    };
                };

                GVAR(Stethoscope_BreathSoundID) = playSoundUI [(format ["ACM_Stethoscope_Breath_%1_%2", _rate, _type]), (linearConversion [0.36, 0.099, ([_leftLungDistance, _rightLungDistance] select _selectLung), (0.3 * _volumeModifier), _volumeModifier, true]), 1, false];
            };
        };
    };
}, IDC_STETHOSCOPE] call EFUNC(core,beginContinuousAction);