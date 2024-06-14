#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle AED vitals tracking
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part Index <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, 2] call ACM_circulation_fnc_handleAED;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if ((_patient getVariable [QGVAR(AED_PFH), -1]) != -1) exitWith {};

private _inVehicle = !(isNull (objectParent _medic));

_patient setVariable [QGVAR(AED_Provider), _patient, true];
_medic setVariable [QGVAR(AED_Target_Patient), _patient, true];
_medic setVariable [QGVAR(AED_Medic_InUse), false, true];

_patient setVariable [QGVAR(AED_StartTime), CBA_missionTime, true];
_patient setVariable [QGVAR(AED_MuteAlarm), true, true];
_patient setVariable [QGVAR(AED_InUse), false, true];

if (_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0] in [1,2,3]) then {
    _patient setVariable [QGVAR(AED_Alarm_CardiacArrest_State), true];
    _patient setVariable [QGVAR(AED_Alarm_State), true];

    [{
        params ["_patient"];

        !([_patient] call FUNC(hasAED)) || (_patient getVariable [QGVAR(AED_InUse), false]);
    }, {}, [_patient], 5, {
        params ["_patient"];

        playSound3D [QPATHTO_R(sound\aed_pushanalyze.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 1.715s
    }] call CBA_fnc_waitUntilAndExecute;
} else {
    _patient setVariable [QGVAR(AED_Alarm_CardiacArrest_State), false];
    _patient setVariable [QGVAR(AED_Alarm_State), false];

    [{
        params ["_patient"];

        _patient setVariable [QGVAR(AED_MuteAlarm), false, true];
    }, [_patient], 5] call CBA_fnc_waitAndExecute;
};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient", "_medic"];

    private _padsStatus = _patient getVariable [QGVAR(AED_Placement_Pads), false];
    private _pulseOximeterPlacement = _patient getVariable [QGVAR(AED_Placement_PulseOximeter), -1];
    private _pulseOximeterPlacementStatus = (_pulseOximeterPlacement != -1 && {HAS_TOURNIQUET_APPLIED_ON(_patient,_pulseOximeterPlacement)});
    private _pressureCuffPlacement = _patient getVariable [QGVAR(AED_Placement_PressureCuff), -1];
    private _capnographStatus = _patient getVariable [QGVAR(AED_Placement_Capnograph), false];

    if (!_padsStatus && _pulseOximeterPlacement == -1 && _pressureCuffPlacement == -1 && !_capnographStatus) exitWith {
        _patient setVariable [QGVAR(AED_Pads_Display), 0, true];
        _patient setVariable [QGVAR(AED_Pads_LastSync), -1];
        _patient setVariable [QGVAR(AED_PulseOximeter_Display), -1, true];
        _patient setVariable [QGVAR(AED_PulseOximeter_LastSync), -1];

        _patient setVariable [QGVAR(AED_Capnograph_LastSync), -1];
        _patient setVariable [QGVAR(AED_RR_Display), 0, true];
        _patient setVariable [QGVAR(AED_CO2_Display), 0, true];

        _patient setVariable [QGVAR(AED_PFH), -1];

        _medic setVariable [QGVAR(AED_Target_Patient), objNull, true];
        _patient setVariable [QGVAR(AED_Provider), objNull, true];

        _patient setVariable [QGVAR(AED_MuteAlarm), false, true];

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _spO2 = [_patient] call EFUNC(breathing,getSpO2);

    if (_padsStatus) then {
        private _lastSync = _patient getVariable [QGVAR(AED_Pads_LastSync), -1];

        private _ekgHR = [_patient] call FUNC(getEKGHeartRate);
        private _rhythmState = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];

        if (_lastSync + 5.25 < CBA_missionTime) then {
            _patient setVariable [QGVAR(AED_Pads_LastSync), CBA_missionTime];
            
            _patient setVariable [QGVAR(AED_Pads_Display), round(_ekgHR), true];
        };

        if ([_patient] call FUNC(AED_IsSilent)) then {
            _patient setVariable [QGVAR(AED_Alarm_CardiacArrest_State), false];
            _patient setVariable [QGVAR(AED_Alarm_State), false];
        };

        if (!(_patient getVariable [QGVAR(AED_InUse), false]) && !([_patient] call FUNC(AED_IsSilent)) && !([_patient] call EFUNC(core,cprActive))) then {
            if (_ekgHR > 0) then {
                private _lastBeep = _patient getVariable [QGVAR(AED_Pads_LastBeep), -1];
                private _hrDelay = 60 / _ekgHR;

                if (!(_patient getVariable [QGVAR(AED_Alarm_State), false]) && {_rhythmState in [2,3]}) then {
                    _patient setVariable [QGVAR(AED_Alarm_State), true];

                    [{
                        params ["_patient"];

                        if !(_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0] in [0,5]) then {
                            [_patient] call FUNC(AED_PlayAlarm);
                            _patient setVariable [QGVAR(AED_Alarm_CardiacArrest_State), true];
                        } else {
                            _patient setVariable [QGVAR(AED_Alarm_State), false];
                        };
                    }, [_patient], 2] call CBA_fnc_waitAndExecute;
                };

                if (_patient getVariable [QGVAR(AED_Alarm_CardiacArrest_State), false]) exitWith {
                    if (_rhythmState in [0,5]) then {
                        _patient setVariable [QGVAR(AED_Alarm_CardiacArrest_State), false];
                        _patient setVariable [QGVAR(AED_Alarm_State), false];
                        playSound3D [QPATHTO_R(sound\aed_3beep.wav), _patient, false, getPosASL _patient, 15, 1, 15]; // 0.369s
                    };
                };

                if ((_lastBeep + _hrDelay) < CBA_missionTime) then {
                    _patient setVariable [QGVAR(AED_Pads_LastBeep), CBA_missionTime];

                    private _pitch = 1;
                    if (_pulseOximeterPlacement != -1) then { // Beep pitch affected by SpO2
                        _pitch = linearConversion [50, 90, ([_patient, true] call EFUNC(breathing,getSpO2)), 0.5, 1, true];
                    };

                    playSound3D [QPATHTO_R(sound\aed_hr_beep.wav), _patient, false, getPosASL _patient, 15, _pitch, 15]; // 0.15s
                };
            } else {
                if !(_patient getVariable [QGVAR(AED_Alarm_State), false]) then {
                    _patient setVariable [QGVAR(AED_Alarm_State), true];

                    [{
                        params ["_patient"];

                        if !(_patient getVariable [QGVAR(CardiacArrest_RhythmState), 0] in [0,5]) then {
                            [_patient] call FUNC(AED_PlayAlarm);
                            _patient setVariable [QGVAR(AED_Alarm_CardiacArrest_State), true];
                        } else {
                            _patient setVariable [QGVAR(AED_Alarm_State), false];
                        };
                    }, [_patient], 2] call CBA_fnc_waitAndExecute;
                };
            };
        };
    };

    if (_pulseOximeterPlacement != -1) then {
        private _lastSync = _patient getVariable [QGVAR(AED_PulseOximeter_LastSync), -1];

        if (_lastSync + 3 < CBA_missionTime) then {
            _patient setVariable [QGVAR(AED_PulseOximeter_LastSync), CBA_missionTime];

            if (!(HAS_TOURNIQUET_APPLIED_ON(_patient,_pulseOximeterPlacement))) then {
                _patient setVariable [QGVAR(AED_PulseOximeter_Display), round(_spO2), true];
                if !(_padsStatus) then {
                    _patient setVariable [QGVAR(AED_Pads_Display), round(GET_HEART_RATE(_patient)), true];
                };
            } else {
                _patient setVariable [QGVAR(AED_PulseOximeter_Display), 0, true];
                if !(_padsStatus) then {
                    _patient setVariable [QGVAR(AED_Pads_Display), 0, true];
                };
            };
        };
    };

    if (_capnographStatus) then {
        private _lastSync = _patient getVariable [QGVAR(AED_Capnograph_LastSync), -1];

        if (_lastSync + 4 < CBA_missionTime) then {
            _patient setVariable [QGVAR(AED_RR_Display), round(GET_RESPIRATION_RATE(_patient)), true];
            _patient setVariable [QGVAR(AED_CO2_Display), round([_patient] call EFUNC(breathing,getEtCO2)), true];
        };
    };
}, 0, [_patient, _medic]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AED_PFH), _PFH];

if (_inVehicle) then {
    [{
        params ["_patient", "_medic"];

        !((objectParent _medic) isEqualTo (objectParent _patient));
    }, {
        params ["_patient", "_medic"];

        if !(isNull _patient) then {
            [_medic, _patient, "body", 0, false, true] call FUNC(setAED);
            [_medic, _patient, "body", 1, false, true] call FUNC(setAED);
            [_medic, _patient, "body", 2, false, true] call FUNC(setAED);
            [_medic, _patient, "body", 3, false, true] call FUNC(setAED);
            [_patient, "activity", "%1 disconnected AED", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
            ["Patient Disconnected", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
        };
    }, [_patient, _medic], 3600] call CBA_fnc_waitUntilAndExecute;
} else {
    [{
        params ["_patient", "_medic"];
    
        (!((objectParent _medic) isEqualTo (objectParent _patient)) || ((_patient distance _medic) > GVAR(AEDDistanceLimit)));
    }, {
        params ["_patient", "_medic"];
        
        if !(isNull _patient) then {
            [_medic, _patient, "body", 0, false, true] call FUNC(setAED);
            [_medic, _patient, "body", 1, false, true] call FUNC(setAED);
            [_medic, _patient, "body", 2, false, true] call FUNC(setAED);
            [_medic, _patient, "body", 3, false, true] call FUNC(setAED);
            [_patient, "activity", "%1 disconnected AED", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
            ["Patient Disconnected", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
        };
    }, [_patient, _medic], 3600] call CBA_fnc_waitUntilAndExecute;
};