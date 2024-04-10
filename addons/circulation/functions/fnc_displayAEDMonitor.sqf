#include "..\script_component.hpp"
#include "..\defines.hpp"
/*
 * Author: Blue
 * Display AED Monitor visuals
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call AMS_circulation_fnc_displayAEDMonitor;
 *
 * Public: No
 */

params ["_medic", "_patient"];

ACEGVAR(medical_gui,pendingReopen) = false; // Prevent medical menu from reopening

if (dialog) then { // If another dialog is open (medical menu) close it
    closeDialog 0;
};

createDialog QGVAR(Lifepak_Monitor_Dialog);

GVAR(EKG_Tick) = -1;

uiNamespace setVariable [QGVAR(AED_DLG),(findDisplay IDC_LIFEPAK_MONITOR)];

private _padsState = [_patient, "", 1] call FUNC(hasAED);
private _pulseOximeterState = [_patient, "", 2] call FUNC(hasAED);

private _rhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];
_patient setVariable [QGVAR(AED_EKGRhythm), _rhythm];

private _HRSpacing = ((([_patient] call FUNC(getEKGHeartRate)) max GET_HEART_RATE(_patient)) / 60) * 5.28;

if (count (_patient getVariable [QGVAR(AED_EKGDisplay), []]) < AED_MONITOR_WIDTH || !(_patient getVariable [QGVAR(AED_Monitor_Pads_State), false])) then { // Initial
    //_ekgDisplay resize [AED_MONITOR_WIDTH, 0];
    if (_padsState) then {
        _patient setVariable [QGVAR(AED_Monitor_Pads_State), true, true];
        if (_rhythm in [-1,0,5]) then {
            _patient setVariable [QGVAR(AED_EKGDisplay), ([_rhythm, _HRSpacing, 0] call FUNC(displayAEDMonitor_generateEKG))];
        } else {
             _patient setVariable [QGVAR(AED_EKGDisplay), ([_rhythm, -1, 0] call FUNC(displayAEDMonitor_generateEKG))];
        };
    };
}; 

if (count (_patient getVariable [QGVAR(AED_PODisplay), []]) < AED_MONITOR_WIDTH || !(_patient getVariable [QGVAR(AED_Monitor_PulseOximeter_State), false])) then { // Initial
    if (_pulseOximeterState) then {
        _patient setVariable [QGVAR(AED_Monitor_PulseOximeter_State), true, true];
        private _saturation = 99;//_patient getVariable [QGVAR(AED_PulseOximeter_Display), 0]; TODO TESTING
        if (_rhythm in [-1,0,5]) then {
            _patient setVariable [QGVAR(AED_PODisplay), ([_rhythm, _HRSpacing, 0, _saturation] call FUNC(displayAEDMonitor_generatePO))];
        } else {
            _patient setVariable [QGVAR(AED_PODisplay), ([_rhythm, -1, 0, _saturation] call FUNC(displayAEDMonitor_generatePO))];
        };
    };
};

// Sync up waveforms
private _monitorArray_EKG = _patient getVariable [QGVAR(AED_EKGDisplay), []];
private _monitorArray_PO = _patient getVariable [QGVAR(AED_PODisplay), []];

for "_i" from 1 to (AED_MONITOR_WIDTH - 1) do { // TODO fix this
    if (_padsState) then {
        [(uiNamespace getVariable [QGVAR(AED_DLG),displayNull]), 0, (_i - 1), (_monitorArray_EKG select (_i - 1)), (_monitorArray_EKG select _i), true] call FUNC(displayAEDMonitor_syncWaveform);
    } else {
        [(uiNamespace getVariable [QGVAR(AED_DLG),displayNull]), 0, (_i - 1), -1, -1, false] call FUNC(displayAEDMonitor_syncWaveform);
    };
    if (_pulseOximeterState) then {
        [(uiNamespace getVariable [QGVAR(AED_DLG),displayNull]), 1, (_i - 1), (_monitorArray_PO select (_i - 1)), (_monitorArray_PO select _i), true] call FUNC(displayAEDMonitor_syncWaveform);
    } else {
        [(uiNamespace getVariable [QGVAR(AED_DLG),displayNull]), 1, (_i - 1), -1, -1, false] call FUNC(displayAEDMonitor_syncWaveform);
    };
};

if (_patient getVariable [QGVAR(AEDMonitorDisplay_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _dlg = (uiNamespace getVariable [QGVAR(AED_DLG),displayNull]);

    private _padsState = [_patient, "", 1] call FUNC(hasAED);
    private _pulseOximeterState = [_patient, "", 2] call FUNC(hasAED);

    private _monitorUpdateStep = (_patient getVariable [QGVAR(AED_UpdateStep), (floor ((CBA_missionTime - (_patient getvariable [QGVAR(AED_StartTime), CBA_missionTime])) mod 6.2304 / 0.0354))]); // x1.18
    private _monitorArray_Offset = _patient getVariable [QGVAR(AED_Offset), 0];

    private _monitorArray_EKGRefresh = _patient getVariable [QGVAR(AED_EKGRefreshDisplay), []];
    private _monitorArray_PORefresh = _patient getVariable [QGVAR(AED_PORefreshDisplay), []];

    private _timeToExpire = (((AED_MONITOR_WIDTH - 1) - _monitorUpdateStep) * 0.03) max 0;

    if (isNull _dlg/* && ((_patient getVariable [QGVAR(AED_RefreshTime), -1]) + _timeToExpire < CBA_missionTime)*/) exitWith {
        systemchat "kill pfh";
        //_patient setVariable [QGVAR(AED_EKGDisplay), _monitorArray_EKGRefresh, true];
        //_patient setVariable [QGVAR(AED_PODisplay), _monitorArray_PORefresh, true];

        _patient setVariable [QGVAR(AED_UpdateStep), nil];
        _patient setVariable [QGVAR(AED_Offset), 0];
        
        _patient setVariable [QGVAR(AEDMonitorDisplay_PFH), -1];
        
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _hr = GET_HEART_RATE(_patient);
    private _rhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];
    private _actualRhythm = 0;
    private _stepSpacing = 8;

    if (_padsState) then {
        if (IN_CRDC_ARRST(_patient)) then {
            _actualRhythm = 1;
            if (alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull])) then {
                _rhythm = -1;
                _actualRhythm = -1;
            };

            switch (_rhythm) do {
                case 1: {
                    _stepSpacing = 0;
                };
                case 2: {
                    _stepSpacing = 0;
                };
                case 3: {
                    _stepSpacing = 0;
                };
                default {
                    _stepSpacing = (_hr / 60) * 5.28;
                };
            };
        } else {
            _stepSpacing = (_hr / 60) * 5.28;
        };
        _rhythm = _rhythm;
    } else {
        _rhythm = -5;
        _monitorArray_Offset = 0;
    };

    _stepSpacing = 0 max (round(_stepSpacing));

    if (_monitorUpdateStep >= (AED_MONITOR_WIDTH - 1) || (_rhythm != _patient getVariable [QGVAR(AED_EKGRhythm), -1]) || _patient getVariable [QGVAR(AED_Monitor_Pads_State), false] != _padsState || _patient getVariable [QGVAR(AED_Monitor_PulseOximeter_State), false] != _pulseOximeterState || {(count _monitorArray_EKGRefresh < AED_MONITOR_WIDTH)}) then { // Handle full pass / update if rhythm changes
        _patient setVariable [QGVAR(AED_RefreshTime), CBA_missionTime];
        _patient setVariable [QGVAR(AED_EKGRhythm), _rhythm];

        _patient setVariable [QGVAR(AED_Monitor_Pads_State), _padsState, true];

        _monitorArray_EKGRefresh = [_rhythm, _stepSpacing, _monitorArray_Offset] call FUNC(displayAEDMonitor_generateEKG);
        _patient setVariable [QGVAR(AED_EKGRefreshDisplay), _monitorArray_EKGRefresh];

        _patient setVariable [QGVAR(AED_Monitor_PulseOximeter_State), _pulseOximeterState, true];

        _monitorArray_PORefresh = [_actualRhythm, _stepSpacing, _monitorArray_Offset, 99] call FUNC(displayAEDMonitor_generatePO); // TODO TESTING
        _patient setVariable [QGVAR(AED_PORefreshDisplay), _monitorArray_PORefresh];

        /*_monitorArray_Offset = _monitorArray_Offset + round (random [-1.4, 0, 1.4]); // TODO look at later
        if (_monitorArray_Offset > 22) then {
            _monitorArray_Offset = 0;
        };*/
        
        //_patient setVariable [QGVAR(AED_Offset), _monitorArray_Offset, true];
    };

    if !(isNull _dlg) then {
        if ((GVAR(EKG_Tick) + 0.03) < CBA_missionTime) then { // Increment step
            GVAR(EKG_Tick) = CBA_missionTime;

            if (_monitorUpdateStep < AED_MONITOR_WIDTH) then {
                _monitorUpdateStep = _monitorUpdateStep + 1;
            } else {
                _monitorUpdateStep = 1;
            };
            
            _patient setVariable [QGVAR(AED_UpdateStep), _monitorUpdateStep];
            
            [_dlg, _patient, _monitorUpdateStep] call FUNC(displayAEDMonitor_updateStep);
        };
        
        // Update vitals displays
        private _displayedHR = _patient getVariable [QGVAR(AED_Pads_Display), 0];
        private _displayedSPO2 = _patient getVariable [QGVAR(AED_PulseOximeter_Display), 0];

        if (_displayedHR < 1) then {
            _displayedHR = "---";
        } else {
            _displayedHR = _displayedHR toFixed 0;
        };
        if (_displayedSPO2 < 1) then {
            _displayedSPO2 = "---";
        } else {
            _displayedSPO2 = _displayedSPO2 toFixed 0;
        };

        ctrlSetText [IDC_VITALSDISPLAY_HR, _displayedHR];
        ctrlSetText [IDC_VITALSDISPLAY_SPO2, _displayedSPO2];
    };
}, 0, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AEDMonitorDisplay_PFH), _PFH];