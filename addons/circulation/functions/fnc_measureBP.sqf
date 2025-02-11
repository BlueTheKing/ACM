#include "..\script_component.hpp"
#include "..\MeasureBP_defines.hpp"
/*
 * Author: Blue
 * Handle manually measuring blood pressure of patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Using stethoscope <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "LeftArm", false] call ACM_circulation_fnc_measureBP;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", ["_stethoscope", false]];

if (_stethoscope) then {
[[_medic, _patient, _bodyPart], { // On Start
    params ["_medic", "_patient", "_bodyPart"];

    GVAR(MeasureBP_HeartBeatSoundID) = -1;
    GVAR(MeasureBP_NextHeartBeat) = -1;
    GVAR(MeasureBP_NextGaugeUpdate) = -1;
    
    GVAR(MeasureBP_Gauge_Target) = 0;
    GVAR(MeasureBP_Gauge) = 0;
    GVAR(MeasureBP_Gauge_DialTarget) = 0;
    GVAR(MeasureBP_Gauge_Dial) = 0;

    createDialog QGVAR(MeasureBP_Dialog);
    uiNamespace setVariable [QGVAR(MeasureBP_DLG),(findDisplay IDC_MEASUREBP)];
    
    ACEGVAR(hearing,volumeAttenuation) = 0.2;
    [ACELLSTRING(Volume,Lowered), 1.5, _medic] call ACEFUNC(common,displayTextStructured);

    private _display = uiNamespace getVariable [QGVAR(MeasureBP_DLG), displayNull];
    private _ctrlText = _display displayCtrl IDC_MEASUREBP_TEXT;
    private _ctrlStethoscope = _display displayCtrl IDC_MEASUREBP_STETHOSCOPE;

    _ctrlStethoscope ctrlShow true;

    private _bodyPartString = ACELLSTRING(Medical_GUI,LeftArm);

    if (_bodyPart == "rightarm") then {
        _bodyPartString = ACELLSTRING(Medical_GUI,RightArm);
    };

    _ctrlText ctrlSetText format ["%1 (%2)", ([_patient, false, true] call ACEFUNC(common,getName)), _bodyPartString];
}, { // On cancel
    params ["_medic", "_patient", "_bodyPart"];

    if !(isNull findDisplay IDC_MEASUREBP) then {
        stopSound GVAR(MeasureBP_HeartBeatSoundID);
        closeDialog 0;
    };

    [LSTRING(MeasureBP_Stopped), 2, _medic] call ACEFUNC(common,displayTextStructured);

    call ACEFUNC(hearing,updateHearingProtection);
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart"];

    private _display = uiNamespace getVariable [QGVAR(MeasureBP_DLG), displayNull];

    private _ctrlDial = _display displayCtrl IDC_MEASUREBP_DIAL;

    private _targetPressure = GVAR(MeasureBP_Gauge_Target);
    private _currentPressure = GVAR(MeasureBP_Gauge);

    if (GVAR(MeasureBP_NextGaugeUpdate) < CBA_missionTime) then {
        if (_targetPressure != _currentPressure) then {
            if (_targetPressure > _currentPressure) then {
                _currentPressure = _currentPressure + 1;
            } else {
                _currentPressure = _currentPressure - 1;
            };

            GVAR(MeasureBP_Gauge) = _currentPressure;
        };

        private _targetDegree = GVAR(MeasureBP_Gauge_DialTarget);
        private _currentDegree = GVAR(MeasureBP_Gauge_Dial);

        if (_targetDegree != _currentDegree) then {
            if (_targetDegree > _currentDegree) then {
                _currentDegree = _currentDegree + 1;
            } else {
                _currentDegree = _currentDegree - 1;
            };

            GVAR(MeasureBP_Gauge_Dial) = _currentDegree;

            private _index = 304 min _currentDegree max 0;

            _ctrlDial ctrlSetText format ["%1%2.paa", QPATHTOEF(circulation,ui\pressurecuff\dial\dial_), _index];
        };

        GVAR(MeasureBP_NextGaugeUpdate) = CBA_missionTime + 0.03;
    };

    private _HR = GET_HEART_RATE(_patient);

    private _partIndex = ALL_BODY_PARTS find _bodyPart;

    if (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex) || !(HAS_PULSE_P(_patient))) then {
        _HR = 0;
    };

    (GET_BLOOD_PRESSURE(_patient)) params ["_BPDiastolic", "_BPSystolic"];

    private _pressureTooLow = 80 > _BPSystolic;

    if (_HR > 0 && !_pressureTooLow && alive _patient) then {
        if (GVAR(MeasureBP_NextHeartBeat) < CBA_missionTime) then {
            private _heartBeatDelay = 60 / _HR;
            GVAR(MeasureBP_NextHeartBeat) = CBA_missionTime + _heartBeatDelay;

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

            private _strength = linearConversion [(80.1), 120, _BPSystolic, 0.01, 1, true];

            if (GVAR(MeasureBP_Gauge_Dial) >= GVAR(MeasureBP_Gauge_DialTarget) && GVAR(MeasureBP_Gauge) <= (_BPSystolic + (20 * _strength)) && GVAR(MeasureBP_Gauge) >= (_BPDiastolic - (20 * _strength))) then {
                GVAR(MeasureBP_Gauge_Dial) = GVAR(MeasureBP_Gauge_Dial) + 2;
            };

            if (GVAR(MeasureBP_Gauge) <= _BPSystolic && GVAR(MeasureBP_Gauge) >= _BPDiastolic) then {
                private _maxVolume = _BPSystolic - (_BPSystolic - _BPDiastolic) / 2;
                private _volume = (linearConversion [40, 0, (abs (GVAR(MeasureBP_Gauge) - _maxVolume)), 0, 0.95, true]) * _strength;
                GVAR(MeasureBP_HeartBeatSoundID) = playSoundUI [(format ["ACM_Stethoscope_HeartBeat_%1_%2", _rate, _variant]), _volume, (1 + (random 0.1)), false];
            };
        };
    };
}, IDC_MEASUREBP] call EFUNC(core,beginContinuousAction);
} else {
[[_medic, _patient, _bodyPart], { // On Start
    #define _x_pos(N) (ACM_MEASUREBP_POS_X(29.5) - (ACM_MEASUREBP_POS_W((1 * N)) / 2))
    #define _y_pos(N) (ACM_MEASUREBP_POS_Y(18) - (ACM_MEASUREBP_POS_H((0.75 * N)) / 2))
    #define _w_pos(N) ((1 * N) * GUI_GRID_W)
    #define _h_pos(N) ((0.75 * N) * GUI_GRID_H)

    params ["_medic", "_patient", "_bodyPart"];

    GVAR(MeasureBP_NextHeartBeat) = -1;
    GVAR(MeasureBP_Heart_Done) = true;
    GVAR(MeasureBP_NextGaugeUpdate) = -1;

    GVAR(MeasureBP_Gauge_Target) = 0;
    GVAR(MeasureBP_Gauge) = 0;
    GVAR(MeasureBP_Gauge_DialTarget) = 0;
    GVAR(MeasureBP_Gauge_Dial) = 0;

    createDialog QGVAR(MeasureBP_Dialog);
    uiNamespace setVariable [QGVAR(MeasureBP_DLG),(findDisplay IDC_MEASUREBP)];

    private _display = uiNamespace getVariable [QGVAR(MeasureBP_DLG), displayNull];
    private _ctrlText = _display displayCtrl IDC_MEASUREBP_TEXT;

    private _ctrlHeart = _display displayCtrl IDC_MEASUREBP_HEART;
    private _ctrlHeartBack = _display displayCtrl IDC_MEASUREBP_HEARTBACK;

    _ctrlHeart ctrlShow true;
    _ctrlHeartBack ctrlShow true;

    private _bodyPartString = ACELLSTRING(Medical_GUI,LeftArm);

    if (_bodyPart == "rightarm") then {
        _bodyPartString = ACELLSTRING(Medical_GUI,RightArm);
    };

    _ctrlText ctrlSetText format ["%1 (%2)", ([_patient, false, true] call ACEFUNC(common,getName)), _bodyPartString];
}, { // On cancel
    params ["_medic", "_patient", "_bodyPart"];

    if !(isNull findDisplay IDC_MEASUREBP) then {
        stopSound GVAR(MeasureBP_HeartBeatSoundID);
        closeDialog 0;
    };

    [LSTRING(MeasureBP_Stopped), 2, _medic] call ACEFUNC(common,displayTextStructured);
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart"];

    private _display = uiNamespace getVariable [QGVAR(MeasureBP_DLG), displayNull];

    private _ctrlHeart = _display displayCtrl IDC_MEASUREBP_HEART;
    private _ctrlDial = _display displayCtrl IDC_MEASUREBP_DIAL;

    private _targetPressure = GVAR(MeasureBP_Gauge_Target);
    private _currentPressure = GVAR(MeasureBP_Gauge);

    if (GVAR(MeasureBP_NextGaugeUpdate) < CBA_missionTime) then {
        if (_targetPressure != _currentPressure) then {
            if (_targetPressure > _currentPressure) then {
                _currentPressure = _currentPressure + 1;
            } else {
                _currentPressure = _currentPressure - 1;
            };

            GVAR(MeasureBP_Gauge) = _currentPressure;
        };

        private _targetDegree = GVAR(MeasureBP_Gauge_DialTarget);
        private _currentDegree = GVAR(MeasureBP_Gauge_Dial);

        if (_targetDegree != _currentDegree) then {
            if (_targetDegree > _currentDegree) then {
                _currentDegree = _currentDegree + 1;
            } else {
                _currentDegree = _currentDegree - 1;
            };

            GVAR(MeasureBP_Gauge_Dial) = _currentDegree;

            private _index = 304 min _currentDegree max 0;

            _ctrlDial ctrlSetText format ["%1%2.paa", QPATHTOEF(circulation,ui\pressurecuff\dial\dial_), _index];
        };

        GVAR(MeasureBP_NextGaugeUpdate) = CBA_missionTime + 0.03;
    };

    private _HR = GET_HEART_RATE(_patient);

    private _partIndex = ALL_BODY_PARTS find _bodyPart;

    if (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex) || !(HAS_PULSE_P(_patient))) then {
        _HR = 0;
    };

    (GET_BLOOD_PRESSURE(_patient)) params ["_BPDiastolic", "_BPSystolic"];

    private _pressureTooLow = 80 > _BPSystolic;

    if (_HR > 0 && !_pressureTooLow && alive _patient) then {
        if (GVAR(MeasureBP_NextHeartBeat) >= CBA_missionTime) exitWith {};

        private _strength = linearConversion [(80.1), 120, _BPSystolic, 0.01, 1, true];

        if (GVAR(MeasureBP_Gauge_Dial) >= GVAR(MeasureBP_Gauge_DialTarget) && GVAR(MeasureBP_Gauge) <= (_BPSystolic + (20 * _strength)) && GVAR(MeasureBP_Gauge) >= (_BPDiastolic - (20 * _strength))) then {
            GVAR(MeasureBP_Gauge_Dial) = GVAR(MeasureBP_Gauge_Dial) + 2;
        };

        private _delay = 60 / _HR;

        GVAR(MeasureBP_NextHeartBeat) = (CBA_missionTime + _delay);
        
        if (GVAR(MeasureBP_Gauge) <= _BPSystolic) then {
            _ctrlHeart ctrlShow true;

            private _pressureEffect = linearConversion [_BPSystolic, (_BPSystolic - 10), GVAR(MeasureBP_Gauge), 0.01, 1, true];
            
            private _fullStrength = (linearConversion [80.1, 140, _BPSystolic, 0.8, 3, true]) * _pressureEffect;
            private _releaseStrength = (linearConversion [80.1, 140, _BPSystolic, 0.5, 2, true]) * _pressureEffect;

            private _beatTime = 0.5 min (0.4 * _delay);
            private _releaseTime = 0.7 min (0.6 * _delay);

            _ctrlHeart ctrlSetPosition [_x_pos(_fullStrength), _y_pos(_fullStrength), _w_pos(_fullStrength), _h_pos(_fullStrength)];
            _ctrlHeart ctrlCommit _beatTime;

            [{
                params ["_ctrlHeart", "_releaseTime", "_releaseStrength"];

                _ctrlHeart ctrlSetPosition [_x_pos(_releaseStrength), _y_pos(_releaseStrength), _w_pos(_releaseStrength), _h_pos(_releaseStrength)];
                _ctrlHeart ctrlCommit _releaseTime;
            }, [_ctrlHeart, _releaseTime, _releaseStrength], _beatTime] call CBA_fnc_waitAndExecute;

            GVAR(MeasureBP_Heart_Hiding) = false;
            GVAR(MeasureBP_Heart_Done) = false;
        } else {
            if (GVAR(MeasureBP_Heart_Done)) then {
                _ctrlHeart ctrlShow false;
                GVAR(MeasureBP_Heart_Hiding) = false;
            } else {
                if !(GVAR(MeasureBP_Heart_Hiding)) then {
                    GVAR(MeasureBP_Heart_Hiding) = true;
                    _ctrlHeart ctrlSetPosition [_x_pos(1), _y_pos(1), _w_pos(1), _h_pos(1)];
                    _ctrlHeart ctrlCommit 1;

                    [{
                        GVAR(MeasureBP_Heart_Done) = true;
                    }, [], 1] call CBA_fnc_waitAndExecute;
                };
            };
        };
    } else {
        if (GVAR(MeasureBP_Heart_Done)) then {
            _ctrlHeart ctrlShow false;
            GVAR(MeasureBP_Heart_Hiding) = false;
        } else {
            if !(GVAR(MeasureBP_Heart_Hiding)) then {
                GVAR(MeasureBP_Heart_Hiding) = true;
                _ctrlHeart ctrlSetPosition [_x_pos(1), _y_pos(1), _w_pos(1), _h_pos(1)];
                _ctrlHeart ctrlCommit 1;

                [{
                    GVAR(MeasureBP_Heart_Done) = true;
                }, [], 1] call CBA_fnc_waitAndExecute;
            };
        };
    };

    private _color = linearConversion [_w_pos(0.5), _w_pos(2.9), ((ctrlPosition _ctrlHeart) select 2), 0.1, 1, false];
    _ctrlHeart ctrlSetTextColor [1, 0, 0, _color];
}, IDC_MEASUREBP] call EFUNC(core,beginContinuousAction);
};