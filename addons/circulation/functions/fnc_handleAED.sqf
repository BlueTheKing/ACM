#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle placing AED
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
 * [player, cursorTarget, 2] call AMS_breathing_fnc_handleAED;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if ((_patient getVariable [QGVAR(AEDMonitor_PFH), -1]) != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _padsStatus = _patient getVariable [QGVAR(AEDMonitor_Placement_Pads), false];
    private _pulseOximeterPlacement = _patient getVariable [QGVAR(AEDMonitor_Placement_PulseOximeter), -1];
    private _pulseOximeterPlacementStatus = (_pulseOximeterPlacement != -1 && {});

    if (!_padsStatus && _pulseOximeterPlacement == -1) exitWith {
        _patient setVariable [QGVAR(AEDMonitor_Pads_Display), 0, true];
        _patient setVariable [QGVAR(AEDMonitor_Pads_LastSync), -1];
        _patient setVariable [QGVAR(AEDMonitor_PulseOximeter_Display), 0, true];
        _patient setVariable [QGVAR(AEDMonitor_PulseOximeter_LastSync), -1];

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _hr = GET_HEART_RATE(_patient);
    private _spO2 = [_patient] call EFUNC(breathing,getSpO2);

    if (_padsStatus) then {
        private _lastSync = _patient getVariable [QGVAR(AEDMonitor_Pads_LastSync), -1];

        if (_lastSync + 5.25 < CBA_missionTime) then {
            _patient setVariable [QGVAR(AEDMonitor_Pads_LastSync), CBA_missionTime];
            
            _patient setVariable [QGVAR(AEDMonitor_Pads_Display), round(_hr), true];
        };
    };

    if (_pulseOximeterPlacement != -1) then {
        private _lastSync = _patient getVariable [QGVAR(AEDMonitor_PulseOximeter_LastSync), -1];

        if (_lastSync + 3 < CBA_missionTime) then {
            _patient setVariable [QGVAR(AEDMonitor_PulseOximeter_LastSync), CBA_missionTime];

            if (!(HAS_TOURNIQUET_APPLIED_ON(_patient,_pulseOximeterPlacement))) then {
                _patient setVariable [QGVAR(AEDMonitor_PulseOximeter_Display), round(_spO2), true];
                if !(_padsStatus) then {
                    _patient setVariable [QGVAR(AEDMonitor_Pads_Display), round(_hr), true];
                };
            } else {
                _patient setVariable [QGVAR(AEDMonitor_PulseOximeter_Display), 0, true];
                if !(_padsStatus) then {
                    _patient setVariable [QGVAR(AEDMonitor_Pads_Display), 0, true];
                };
            };
        };
    };
}, 0.05, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AEDMonitor_PFH), _PFH];

[{
    params ["_patient", "_medic"];

    !((objectParent _medic) isEqualTo (objectParent _patient)) || ((_patient distance _medic) > 5) // TODO add setting
}, {
    params ["_patient", "_medic"];
    
    if !(isNull _patient) then {
        [_medic, _patient, "body", 0, false] call FUNC(setAED);
        [_medic, _patient, "body", 1, false] call FUNC(setAED);
        ["Patient Disconnected", 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    };
}, [_patient, _medic], 3600] call CBA_fnc_waitUntilAndExecute;