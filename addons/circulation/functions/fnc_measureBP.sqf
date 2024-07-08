#include "..\script_component.hpp"
#include "..\MeasureBP_defines.hpp"
/*
 * Author: Blue
 * Handle manually measuring blood pressure of patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <OBJECT>
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
    
    GVAR(MeasureBP_Gauge_Pressure) = 0;
    GVAR(MeasureBP_Gauge_Offset) = 0;
    GVAR(MeasureBP_Gauge_Target) = 90;
    GVAR(MeasureBP_Gauge) = 90;

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
    params ["_medic", "_patient", "_bodyPart", "", "_notInVehicle"];

    if !(isNull findDisplay IDC_MEASUREBP) then {
        stopSound GVAR(MeasureBP_HeartBeatSoundID);
        closeDialog 0;
    };

    if (_notInVehicle) then {
        [_medic, "AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation);
    };

    ["Stopped measuring blood pressure", 2, _medic] call ACEFUNC(common,displayTextStructured);

    call ACEFUNC(hearing,updateHearingProtection);
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart"];

    private _display = uiNamespace getVariable [QGVAR(MeasureBP_DLG), displayNull];

    private _targetDegree = GVAR(MeasureBP_Gauge_Target);
    private _currentDegree = GVAR(MeasureBP_Gauge);

    if (_targetDegree != _currentDegree) then {
        if (_targetDegree > _currentDegree) then {
            _currentDegree = _currentDegree + 0.5;
        } else {
            _currentDegree = _currentDegree - 0.5;
        };

        GVAR(MeasureBP_Gauge) = _currentDegree;
    };

    private _ctrlGaugeDial_1 = _display displayCtrl IDC_MEASUREBP_DIAL_1;
    private _ctrlGaugeDial_2 = _display displayCtrl IDC_MEASUREBP_DIAL_2;

    private _dial_1_Pos = ctrlPosition _ctrlGaugeDial_1;
    private _dial_2_Pos = ctrlPosition _ctrlGaugeDial_2;

    _ctrlGaugeDial_1 ctrlSetPosition [(_dial_1_Pos select 0), (_dial_1_Pos select 1), (ACM_MEASUREBP_pxToScreen_W(round (MEASUREBP_DIAL_LENGTH * cos GVAR(MeasureBP_Gauge)))), (ACM_MEASUREBP_pxToScreen_H(round (MEASUREBP_DIAL_LENGTH * sin GVAR(MeasureBP_Gauge))))];
    _ctrlGaugeDial_1 ctrlCommit 0;
    _ctrlGaugeDial_2 ctrlSetPosition [(_dial_2_Pos select 0), (_dial_2_Pos select 1), (ACM_MEASUREBP_pxToScreen_W(round (MEASUREBP_DIAL_LENGTH * cos GVAR(MeasureBP_Gauge)))), (ACM_MEASUREBP_pxToScreen_H(round (MEASUREBP_DIAL_LENGTH * sin GVAR(MeasureBP_Gauge))))];
    _ctrlGaugeDial_2 ctrlCommit 0;

    private _HR = GET_HEART_RATE(_patient);

    private _partIndex = ALL_BODY_PARTS find _bodyPart;

    if (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex)) then {
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

            private _gaugeActual = (GVAR(MeasureBP_Gauge) - GVAR(MeasureBP_Gauge_Offset) - 90);

            if (_gaugeActual <= (_BPSystolic + (20 * _strength)) && _gaugeActual >= (_BPDiastolic - (20 * _strength))) then {
                GVAR(MeasureBP_Gauge) = GVAR(MeasureBP_Gauge) + 3;
            };

            if (_gaugeActual <= _BPSystolic && _gaugeActual >= _BPDiastolic) then {
                private _maxVolume = _BPSystolic - (_BPSystolic - _BPDiastolic) / 2;
                private _volume = (linearConversion [40, 0, (abs (_gaugeActual - _maxVolume)), 0, 1, true]) * _strength;
                GVAR(MeasureBP_HeartBeatSoundID) = playSoundUI [(format ["ACM_Stethoscope_HeartBeat_%1_%2", _rate, _variant]), _volume, (1 + (random 0.1)), false];
            };
        };
    };
}, IDC_MEASUREBP] call EFUNC(core,beginContinuousAction);
} else {
[[_medic, _patient, _bodyPart], { // On Start
    #define _x_pos(mult) (safezoneX + (safezoneW / 2) - (safezoneW / (160 / mult)) + 0.03)
    #define _y_pos(mult) (safezoneY + (safezoneH / 2) - (safezoneH / (160 / mult)) + 0.18)

    #define _w_pos(mult) (safezoneW / (80 / mult))
    #define _h_pos(mult) (safezoneH / (80 / mult))

    params ["_medic", "_patient", "_bodyPart"];

    GVAR(MeasureBP_NextHeartBeat) = -1;
    GVAR(MeasureBP_Heart_Done) = true;

    GVAR(MeasureBP_Gauge_Pressure) = 0;
    GVAR(MeasureBP_Gauge_Offset) = 0;
    GVAR(MeasureBP_Gauge_Target) = 90;
    GVAR(MeasureBP_Gauge) = 90;

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
    params ["_medic", "_patient", "_bodyPart", "", "_notInVehicle"];

    if !(isNull findDisplay IDC_MEASUREBP) then {
        stopSound GVAR(MeasureBP_HeartBeatSoundID);
        closeDialog 0;
    };

    if (_notInVehicle) then {
        [_medic, "AmovPknlMstpSnonWnonDnon", 2] call ACEFUNC(common,doAnimation);
    };

    ["Stopped measuring blood pressure", 2, _medic] call ACEFUNC(common,displayTextStructured);
}, { // PerFrame
    params ["_medic", "_patient", "_bodyPart"];

    private _display = uiNamespace getVariable [QGVAR(MeasureBP_DLG), displayNull];

    private _ctrlHeart = _display displayCtrl IDC_MEASUREBP_HEART;

    private _targetDegree = GVAR(MeasureBP_Gauge_Target);
    private _currentDegree = GVAR(MeasureBP_Gauge);

    if (_targetDegree != _currentDegree) then {
        if (_targetDegree > _currentDegree) then {
            _currentDegree = _currentDegree + 0.5;
        } else {
            _currentDegree = _currentDegree - 0.5;
        };

        GVAR(MeasureBP_Gauge) = _currentDegree;
    };

    private _ctrlGaugeDial_1 = _display displayCtrl IDC_MEASUREBP_DIAL_1;
    private _ctrlGaugeDial_2 = _display displayCtrl IDC_MEASUREBP_DIAL_2;

    private _dial_1_Pos = ctrlPosition _ctrlGaugeDial_1;
    private _dial_2_Pos = ctrlPosition _ctrlGaugeDial_2;

    _ctrlGaugeDial_1 ctrlSetPosition [(_dial_1_Pos select 0), (_dial_1_Pos select 1), (ACM_MEASUREBP_pxToScreen_W(round (MEASUREBP_DIAL_LENGTH * cos GVAR(MeasureBP_Gauge)))), (ACM_MEASUREBP_pxToScreen_H(round (MEASUREBP_DIAL_LENGTH * sin GVAR(MeasureBP_Gauge))))];
    _ctrlGaugeDial_1 ctrlCommit 0;
    _ctrlGaugeDial_2 ctrlSetPosition [(_dial_2_Pos select 0), (_dial_2_Pos select 1), (ACM_MEASUREBP_pxToScreen_W(round (MEASUREBP_DIAL_LENGTH * cos GVAR(MeasureBP_Gauge)))), (ACM_MEASUREBP_pxToScreen_H(round (MEASUREBP_DIAL_LENGTH * sin GVAR(MeasureBP_Gauge))))];
    _ctrlGaugeDial_2 ctrlCommit 0;

    private _HR = GET_HEART_RATE(_patient);

    private _partIndex = ALL_BODY_PARTS find _bodyPart;

    if (HAS_TOURNIQUET_APPLIED_ON(_patient,_partIndex)) then {
        _HR = 0;
    };

    (GET_BLOOD_PRESSURE(_patient)) params ["_BPDiastolic", "_BPSystolic"];

    private _pressureTooLow = 80 > _BPSystolic;

    private _gaugeActual = (GVAR(MeasureBP_Gauge) - GVAR(MeasureBP_Gauge_Offset) - 90);
    private _strength = linearConversion [_BPSystolic, (_BPSystolic - 10), _gaugeActual, 0.01, 1, true];

    if (_gaugeActual > _BPSystolic) then {
        _HR = 0;
    };

    if (_HR > 0 && !_pressureTooLow && alive _patient) then {
        _ctrlHeart ctrlShow true;

        if (GVAR(MeasureBP_NextHeartBeat) < CBA_missionTime) then {
            private _heartBeatDelay = 60 / _HR;
            GVAR(MeasureBP_NextHeartBeat) = CBA_missionTime + _heartBeatDelay;

            if (_gaugeActual <= (_BPSystolic + (20 * _strength)) && _gaugeActual >= (_BPDiastolic - (20 * _strength))) then {
                GVAR(MeasureBP_Gauge) = GVAR(MeasureBP_Gauge) + 3;
            };

            private _beatTime = 0.5 min (0.4 * _heartBeatDelay);
            private _releaseTime = 0.7 min (0.6 * _heartBeatDelay);

            private _maxStrength = _strength * (linearConversion [(80.1), 120, _BPSystolic, 0.01, 1, true]) * 3;

            _ctrlHeart ctrlSetPosition [_x_pos(_maxStrength), _y_pos(_maxStrength), _w_pos(_maxStrength), _h_pos(_maxStrength)];
            _ctrlHeart ctrlCommit _beatTime;

            [{
                params ["_ctrlHeart", "_releaseTime"];

                _ctrlHeart ctrlSetPosition [_x_pos(1), _y_pos(1), _w_pos(1), _h_pos(1)];
                _ctrlHeart ctrlCommit _releaseTime;
            }, [_ctrlHeart, _releaseTime], _beatTime] call CBA_fnc_waitAndExecute;

            GVAR(MeasureBP_Heart_Hiding) = false;
            GVAR(MeasureBP_Heart_Done) = false;
        };
    } else {
        if (GVAR(MeasureBP_Heart_Done)) then {
            _ctrlHeart ctrlShow false;
            GVAR(MeasureBP_Heart_Hiding) = false;
        } else {
            if !(GVAR(MeasureBP_Heart_Hiding)) then {
                GVAR(MeasureBP_Heart_Hiding) = true;
                _ctrlHeart ctrlSetPosition [_x_pos(0.1), _y_pos(0.1), _w_pos(0.1), _h_pos(0.1)];
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