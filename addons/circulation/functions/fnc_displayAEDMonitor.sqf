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
 * [player, cursorTarget] call ACM_circulation_fnc_displayAEDMonitor;
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

private _padsState = [objNull, _patient, "", 1] call FUNC(hasAED);
private _pulseOximeterState = [objNull, _patient, "", 2] call FUNC(hasAED);
_patient setVariable [QGVAR(AED_Monitor_HR), GET_HEART_RATE(_patient)];

private _saturation = _patient getVariable [QGVAR(AED_PulseOximeter_Display), -1];
_patient setVariable [QGVAR(AED_Monitor_OxygenSaturation), _saturation];

private _rhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];
_patient setVariable [QGVAR(AED_EKGRhythm), _rhythm];

private _recentShock = (_patient getVariable [QGVAR(AED_LastShock), -1]) + 45 > CBA_missionTime;

private _HRSpacing = 0;

if (_rhythm in [-1,0,5]) then {
    if (_rhythm == 5) then { // PEA
        _HRSpacing = (60 / ([_patient] call FUNC(getEKGHeartRate))) * 20;
    } else {
        if (GET_HEART_RATE(_patient) > 0) then {
            _HRSpacing = (60 / GET_HEART_RATE(_patient)) * 20;
        } else {
            _HRSpacing = 0;
        };
    };
};

if (count (_patient getVariable [QGVAR(AED_EKGDisplay), []]) < AED_MONITOR_WIDTH || !(_patient getVariable [QGVAR(AED_Monitor_Pads_State), false])) then { // Initial
    //_ekgDisplay resize [AED_MONITOR_WIDTH, 0];
    if (_padsState) then {
        _patient setVariable [QGVAR(AED_Monitor_Pads_State), true, true];
        if (_rhythm in [-1,0,5]) then {
            _patient setVariable [QGVAR(AED_EKGDisplay), ([_rhythm, _HRSpacing, 0] call FUNC(displayAEDMonitor_generateEKG))];
        } else {
            if (_recentShock) then {
                _patient setVariable [QGVAR(AED_EKGDisplay), ([1, -1, 0] call FUNC(displayAEDMonitor_generateEKG))];
            } else {
                _patient setVariable [QGVAR(AED_EKGDisplay), ([_rhythm, -1, 0] call FUNC(displayAEDMonitor_generateEKG))];
            };
        };
    };
}; 

if (count (_patient getVariable [QGVAR(AED_PODisplay), []]) < AED_MONITOR_WIDTH || !(_patient getVariable [QGVAR(AED_Monitor_PulseOximeter_State), false])) then { // Initial
    if (_pulseOximeterState) then {
        _patient setVariable [QGVAR(AED_Monitor_PulseOximeter_State), true, true];
        if (_rhythm in [-1,0,5]) then {
            _patient setVariable [QGVAR(AED_PODisplay), ([_rhythm, _HRSpacing, 0, _saturation] call FUNC(displayAEDMonitor_generatePO))];
        } else {
            if (_recentShock) then {
                _patient setVariable [QGVAR(AED_PODisplay), ([1, -1, 0, _saturation] call FUNC(displayAEDMonitor_generatePO))];
            } else {
                _patient setVariable [QGVAR(AED_PODisplay), ([_rhythm, -1, 0, _saturation] call FUNC(displayAEDMonitor_generatePO))];
            };
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

    private _padsState = [objNull, _patient, "", 1] call FUNC(hasAED);
    private _pulseOximeterState = [objNull, _patient, "", 2] call FUNC(hasAED);

    private _oxygenSaturation = _patient getVariable [QGVAR(AED_PulseOximeter_Display), -1];

    private _monitorUpdateStep = (_patient getVariable [QGVAR(AED_UpdateStep), (floor ((CBA_missionTime - (_patient getvariable [QGVAR(AED_StartTime), CBA_missionTime])) mod 6.2304 / 0.0354))]); // x1.18
    private _monitorArray_Offset = _patient getVariable [QGVAR(AED_Offset), 0];

    private _monitorArray_EKGRefresh = _patient getVariable [QGVAR(AED_EKGRefreshDisplay), []];
    private _monitorArray_PORefresh = _patient getVariable [QGVAR(AED_PORefreshDisplay), []];

    private _timeToExpire = (((AED_MONITOR_WIDTH - 1) - _monitorUpdateStep) * 0.03) max 0;

    if (isNull _dlg) exitWith {
        //_patient setVariable [QGVAR(AED_EKGDisplay), _monitorArray_EKGRefresh, true];
        //_patient setVariable [QGVAR(AED_PODisplay), _monitorArray_PORefresh, true];

        _patient setVariable [QGVAR(AED_UpdateStep), nil];
        _patient setVariable [QGVAR(AED_Offset), 0];
        
        _patient setVariable [QGVAR(AEDMonitorDisplay_PFH), -1];
        
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _hr = GET_HEART_RATE(_patient);
    private _rhythmState = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];
    private _EKGRhythm = -5;
    private _PORhythm = -5;
    private _stepSpacing = 8;

    switch (true) do {
        case (alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull])): { // CPR
            if (_padsState) then {
                _EKGRhythm = -1;
            };
            if (_pulseOximeterState) then {
                _PORhythm = -1;
            };
            _stepSpacing = (60 / _hr) * 20;
        };
        case ((_patient getVariable [QGVAR(AED_LastShock), -1]) + 30 > CBA_missionTime): { // After shock
            if (_padsState) then {
                _EKGRhythm = 1;
            };
            if (_pulseOximeterState) then {
                _PORhythm = 1;
            };
            _stepSpacing = 0;
        };
        case (IN_CRDC_ARRST(_patient)): {
            if (_padsState) then {
                _EKGRhythm = _rhythmState;
                if (_EKGRhythm == 5) then { // PEA
                    _hr = [_patient] call FUNC(getEKGHeartRate);
                    _stepSpacing = (60 / _hr) * 20;
                };
            };
            if (_pulseOximeterState) then {
                _PORhythm = 1;
            };
            _stepSpacing = 0;
        };
        default { // Sinus
            if (_padsState) then {
                _EKGRhythm = _rhythmState;
            };
            if (_pulseOximeterState && _oxygenSaturation != -1) then {
                _PORhythm = _rhythmState;
            };
            _stepSpacing = (60 / _hr) * 20;
        };
    };

    _stepSpacing = 0 max (round(_stepSpacing));

    private _stepCondition = _monitorUpdateStep >= (AED_MONITOR_WIDTH - 1);
    private _rhythmChangeCondition = _EKGRhythm != _patient getVariable [QGVAR(AED_EKGRhythm), -2] || _PORhythm != _patient getVariable [QGVAR(AED_PORhythm), -2];
    private _vitalsCondition = (abs ((_patient getVariable [QGVAR(AED_Monitor_HR), false]) - _hr) > 10) || (abs ((_patient getVariable [QGVAR(AED_Monitor_OxygenSaturation), false]) - _oxygenSaturation) > 6);
    private _connectedCondition = _patient getVariable [QGVAR(AED_Monitor_Pads_State), false] != _padsState || _patient getVariable [QGVAR(AED_Monitor_PulseOximeter_State), false] != _pulseOximeterState;
    private _listCondition = (count _monitorArray_EKGRefresh < AED_MONITOR_WIDTH) || (count _monitorArray_PORefresh < AED_MONITOR_WIDTH);

    if (_stepCondition || {_vitalsCondition || {_rhythmChangeCondition || {_connectedCondition || {_listCondition}}}}) then { // Handle full pass / force update if rhythm changes/vitals change/device is disconnected
        _patient setVariable [QGVAR(AED_EKGRhythm), _EKGRhythm];
        _patient setVariable [QGVAR(AED_PORhythm), _PORhythm];

        _monitorArray_EKGRefresh = [_EKGRhythm, _stepSpacing, _monitorArray_Offset] call FUNC(displayAEDMonitor_generateEKG);
        _monitorArray_PORefresh = [_PORhythm, _stepSpacing, _monitorArray_Offset, _oxygenSaturation] call FUNC(displayAEDMonitor_generatePO);

        if (_vitalsCondition) then {
            private _EKGArray = [];
            _EKGArray resize AED_MONITOR_WIDTH;

            {
                private _index = _forEachIndex + _monitorUpdateStep;

                if (_index > (AED_MONITOR_WIDTH-1)) then {
                    _index = _index - AED_MONITOR_WIDTH;
                };

                _EKGArray set [_index, _x];
            } forEach _monitorArray_EKGRefresh;

            _monitorArray_EKGRefresh = _EKGArray;

            private _POArray = [];
            _POArray resize AED_MONITOR_WIDTH;

            {
                private _index = _forEachIndex + _monitorUpdateStep;

                if (_index > (AED_MONITOR_WIDTH-1)) then {
                    _index = _index - AED_MONITOR_WIDTH;
                };

                _POArray set [_index, _x];
            } forEach _monitorArray_PORefresh;

            _monitorArray_PORefresh = _POArray;
        };

        _patient setVariable [QGVAR(AED_EKGRefreshDisplay), _monitorArray_EKGRefresh];
        _patient setVariable [QGVAR(AED_PORefreshDisplay), _monitorArray_PORefresh];

        _patient setVariable [QGVAR(AED_Monitor_Pads_State), _padsState];
        _patient setVariable [QGVAR(AED_Monitor_PulseOximeter_State), _pulseOximeterState];
        _patient setVariable [QGVAR(AED_Monitor_OxygenSaturation), _oxygenSaturation];
        _patient setVariable [QGVAR(AED_Monitor_HR), _hr];

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
        private _displayedNIBP = _patient getVariable [QGVAR(AED_NIBP_Display), [0,0]];
        private _displayedRR = _patient getVariable [QGVAR(AED_RR_Display), 0];
        private _displayedCO2 = _patient getVariable [QGVAR(AED_CO2_Display), 0];

        private _displayedNIBP_M = 0;

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

        _displayedNIBP params ["_displayedNIBP_S", "_displayedNIBP_D"];

        if (_displayedNIBP_D < 1 || _displayedNIBP_S < 1) then {
            _displayedNIBP_S = "---";
            _displayedNIBP_D = "---";
            _displayedNIBP_M = "--";
        } else {
            _displayedNIBP_M = (2/3) * _displayedNIBP_S + (1/3) * _displayedNIBP_D;
            _displayedNIBP_M = _displayedNIBP_M toFixed 0;
            _displayedNIBP_S = _displayedNIBP_S toFixed 0;
            _displayedNIBP_D = _displayedNIBP_D toFixed 0;
        };

        if (_displayedRR < 1 || _displayedCO2 < 1) then {
            _displayedRR = "--";
            _displayedCO2 = "---";
        } else {
            _displayedRR = _displayedRR toFixed 0;
            _displayedCO2 = _displayedCO2 toFixed 0;
        };

        ctrlSetText [IDC_VITALSDISPLAY_HR, _displayedHR];
        ctrlSetText [IDC_VITALSDISPLAY_SPO2, _displayedSPO2];
        ctrlSetText [IDC_VITALSDISPLAY_NIBP_S, _displayedNIBP_S];
        ctrlSetText [IDC_VITALSDISPLAY_NIBP_D, _displayedNIBP_D];
        ctrlSetText [IDC_VITALSDISPLAY_NIBP_M, _displayedNIBP_M];
        ctrlSetText [IDC_VITALSDISPLAY_RR, _displayedRR];
        ctrlSetText [IDC_VITALSDISPLAY_CO2, _displayedCO2];

        private _HRNumber = _dlg displayCtrl IDC_VITALSDISPLAY_HR;
        private _HRText = _dlg displayCtrl IDC_VITALSDISPLAY_HR_TEXT;

        if (!_padsState && _pulseOximeterState) then {
            ctrlSetText [IDC_VITALSDISPLAY_HR_TEXT, "PR (SpO2)"];
            _HRNumber ctrlSetTextColor SPO2_COLOR_M;
            _HRText ctrlSetTextColor SPO2_COLOR_M;
        } else {
            ctrlSetText [IDC_VITALSDISPLAY_HR_TEXT, "HR"];
            _HRNumber ctrlSetTextColor HR_COLOR_M;
            _HRText ctrlSetTextColor HR_COLOR_M;
        };
    };
}, 0, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AEDMonitorDisplay_PFH), _PFH];