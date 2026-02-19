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

[_patient, "activity", LSTRING(Stethoscope_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[[_medic, _patient, _bodyPart], { // On Start
    params ["_medic", "_patient", "_bodyPart"];

    [_patient] call FUNC(updateLungState); // TODO to be moved probably

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
    _ctrlText ctrlSetText format ["%1 (%2)", [_patient, false, true] call ACEFUNC(common,getName), ACELLSTRING(medical_gui,Torso)];
}, { // On cancel
    params ["_medic", "_patient", "_bodyPart"];

    stopSound GVAR(Stethoscope_BreathSoundID);
    stopSound GVAR(Stethoscope_BeatSoundID);

    if !(isNull findDisplay IDC_STETHOSCOPE) then {
        closeDialog 0;
    };

    [LSTRING(Stethoscope_Stopped), 1.5, _medic] call ACEFUNC(common,displayTextStructured);

    [-1] call ACEFUNC(hearing,updateHearingProtection);
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart"];

    private _display = uiNamespace getVariable [QGVAR(Stethoscope_DLG), displayNull];
    private _ctrlBell = _display displayCtrl IDC_STETHOSCOPE_BELL;
    private _ctrlBellCenter = [(((ctrlPosition _ctrlBell) select 0) + (((ctrlPosition _ctrlBell) select 2) / 2)), (((ctrlPosition _ctrlBell) select 1) + (((ctrlPosition _ctrlBell) select 3) / 2))];

    private _ctrlRightLungSpace = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_RIGHTLUNG_SPACE);
    private _ctrlRightLungSpace2 = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_RIGHTLUNG_SPACE_2);
    private _rightLungProximity = ([_ctrlRightLungSpace, _ctrlBellCenter] call EFUNC(GUI,inZone)) || ([_ctrlRightLungSpace2, _ctrlBellCenter] call EFUNC(GUI,inZone));

    private _ctrlLeftLungSpace = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_LEFTLUNG_SPACE);
    private _ctrlLeftLungSpace2 = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_LEFTLUNG_SPACE_2);
    private _leftLungProximity = ([_ctrlLeftLungSpace, _ctrlBellCenter] call EFUNC(GUI,inZone)) || ([_ctrlLeftLungSpace2, _ctrlBellCenter] call EFUNC(GUI,inZone));

    private _ctrlRightLungPoint_Bronchial = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_RIGHTLUNG_BRONCHIAL);
    private _ctrlRightLungPoint_BronchoVesticular = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_RIGHTLUNG_BRONCHOVESTICULAR);
    private _ctrlRightLungPoint_VesticularMiddle = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_RIGHTLUNG_VESTICULAR_MIDDLE);
    private _ctrlRightLungPoint_VesticularLower = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_RIGHTLUNG_VESTICULAR_LOWER);

    private _ctrlLeftLungPoint_Bronchial = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_LEFTLUNG_BRONCHIAL);
    private _ctrlLeftLungPoint_BronchoVesticular = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_LEFTLUNG_BRONCHOVESTICULAR);
    private _ctrlLeftLungPoint_VesticularMiddle = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_LEFTLUNG_VESTICULAR_MIDDLE);
    private _ctrlLeftLungPoint_VesticularLower = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_LEFTLUNG_VESTICULAR_LOWER);

    private _ctrlRightSide = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_RIGHTSIDE);
    private _ctrlLeftSide = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_LEFTSIDE);

    private _activeChestSide = switch (true) do {
        case ([_ctrlRightSide, _ctrlBellCenter] call EFUNC(GUI,inZone)): {0};
        case ([_ctrlLeftSide, _ctrlBellCenter] call EFUNC(GUI,inZone)): {1};
        default {-1};
    };

    private _activeLungListeningPoint = -1;
    private _lungLoudness = 0;
    
    if (_activeChestSide > -1) then {
        _lungLoudness = [0.02, 0.25] select (_rightLungProximity || _leftLungProximity);

        {
            if ([_x, _ctrlBellCenter] call EFUNC(GUI,inZone)) then {
                _activeLungListeningPoint = _forEachIndex;
                break;
            };
        } forEach ([[_ctrlRightLungPoint_Bronchial, _ctrlRightLungPoint_BronchoVesticular, _ctrlRightLungPoint_VesticularMiddle, _ctrlRightLungPoint_VesticularLower], [_ctrlLeftLungPoint_Bronchial, _ctrlLeftLungPoint_BronchoVesticular, _ctrlLeftLungPoint_VesticularMiddle, _ctrlLeftLungPoint_VesticularLower]] select _activeChestSide);
    };

    private _ctrlHeartPoint_1 = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_HEART_1);
    private _ctrlHeartPoint_2 = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_HEART_2);
    private _ctrlHeartPoint_3 = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_HEART_3);
    private _ctrlHeartPoint_4 = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_HEART_4);

    private _activeHeartListeningPoint = -1;
    {
        if ([_x, _ctrlBellCenter] call EFUNC(GUI,inZone)) then {
            _activeHeartListeningPoint = _forEachIndex;
            break;
        };
    } forEach [_ctrlHeartPoint_1,_ctrlHeartPoint_2,_ctrlHeartPoint_3,_ctrlHeartPoint_4];

    private _ctrlHeartCenter = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_HEART_CENTER);
    private _ctrlHeartCenterPoint = [((_ctrlHeartCenter select 0) + ((_ctrlHeartCenter select 2) / 2)), ((_ctrlHeartCenter select 1) + ((_ctrlHeartCenter select 3) / 2))];

    private _heartCenterDistance = (_ctrlHeartCenterPoint distance2D _ctrlBellCenter);
    private _heartLoudness = (linearConversion [0.36, 0.1, _heartCenterDistance, 0.03, 0.5, true]);

    private _ctrlBoneSpace_Sternum = ctrlPosition (_display displayCtrl IDC_STETHOSCOPE_BONE_STERNUM);

    private _boneProximity = [_ctrlBoneSpace_Sternum, _ctrlBellCenter] call EFUNC(GUI,inZone);

    if (GVAR(Stethoscope_BellMoving)) then {
        getMousePosition params ["_mouseX", "_mouseY"];

        (ctrlPosition _ctrlBell) params ["","","_bellW","_bellH"];

        _ctrlBell ctrlSetTooltip LLSTRING(Stethoscope_PlaceBell);
        
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
    } else {
        _ctrlBell ctrlSetTooltip LLSTRING(Stethoscope_MoveBell);

        private _HR = GET_HEART_RATE(_patient);
        private _RR = GET_RESPIRATION_RATE(_patient);

        if (_HR > 0 && alive _patient) then {
            if (GVAR(Stethoscope_NextBeat) < CBA_missionTime) then {
                private _heartBeatDelay = 60 / _HR;
                GVAR(Stethoscope_NextBeat) = CBA_missionTime + _heartBeatDelay;

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

                _heartLoudness = [_heartLoudness, 0.95] select (_activeHeartListeningPoint > -1);
                _heartLoudness = [_heartLoudness, (_heartLoudness min 0.1)] select _boneProximity;

                GVAR(Stethoscope_BeatSoundID) = playSoundUI [(format ["ACM_Stethoscope_HeartBeat_%1_%2", _rate, _variant]), _heartLoudness, (1 + (random 0.1)), false];
            };
            if (_RR < 1) exitWith {};
            if (GVAR(Stethoscope_NextBreath) < CBA_missionTime) then {
                private _breathDelay = 60 / _RR;
                GVAR(Stethoscope_NextBreath) = CBA_missionTime + _breathDelay;

                if (_activeHeartListeningPoint > -1) exitWith {};
                if (_activeChestSide == -1) exitWith {};

                private _volumeModifier = 1;

                private _type = switch (((_patient getVariable [QGVAR(Stethoscope_LungState), [0,0]]) select _activeChestSide)) do {
                    case 1: {
                        _volumeModifier = 0.8;
                        "Shallow";
                    };
                    case 2: {
                        _volumeModifier = 0.3;
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

                _lungLoudness = [_lungLoudness, 0.95] select (_activeLungListeningPoint > -1);
                _lungLoudness = [_lungLoudness, (_lungLoudness min 0.1)] select _boneProximity;

                GVAR(Stethoscope_BreathSoundID) = playSoundUI [(format ["ACM_Stethoscope_Breath_%1_%2", _rate, _type]), (_lungLoudness * _volumeModifier), 1, false];
            };
        };
    };
}, false, IDC_STETHOSCOPE] call EFUNC(core,beginContinuousAction);