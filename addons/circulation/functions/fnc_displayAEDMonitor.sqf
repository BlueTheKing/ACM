#include "..\script_component.hpp"
#include "..\Defibrillator_defines.hpp"
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

GVAR(AED_Monitor_Target) = _patient;

uiNamespace setVariable [QGVAR(AEDMonitor_DLG),(findDisplay IDC_LIFEPAK_MONITOR)];

private _padsState = [_patient, "", 1] call FUNC(hasAED);
private _pulseOximeterState = [_patient, "", 2] call FUNC(hasAED);
private _capnographState = [_patient, "", 4] call FUNC(hasAED);
_patient setVariable [QGVAR(AED_Monitor_HR), GET_HEART_RATE(_patient)];

private _saturation = _patient getVariable [QGVAR(AED_PulseOximeter_Display), -1];
_patient setVariable [QGVAR(AED_Monitor_OxygenSaturation), _saturation];

private _etco2 = _patient getVariable [QGVAR(AED_CO2_Display), 0];
private _rr = GET_RESPIRATION_RATE(_patient);
_patient setVariable [QGVAR(AED_Monitor_EtCO2), _etco2];

private _rhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];

if !(alive _patient) then {
    _rhythm = 1
};

_patient setVariable [QGVAR(AED_EKGRhythm), _rhythm];

private _recentShock = [_patient, true] call FUNC(recentAEDShock);

private _HRSpacing = 0;

if (_rhythm in [-1,0,5]) then {
    if (_rhythm == 5) then { // PEA
        _HRSpacing = (60 / ([_patient] call FUNC(getEKGHeartRate))) * AED_SPACING_MULTIPLIER;
    } else {
        if (GET_HEART_RATE(_patient) > 0) then {
            _HRSpacing = (60 / GET_HEART_RATE(_patient)) * AED_SPACING_MULTIPLIER;
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
            _patient setVariable [QGVAR(AED_EKGDisplay), (([_rhythm, _HRSpacing, 0] call FUNC(displayAEDMonitor_generateEKG)) select 0)];
        } else {
            if (_recentShock) then {
                _patient setVariable [QGVAR(AED_EKGDisplay), (([1, -1, 0] call FUNC(displayAEDMonitor_generateEKG)) select 0)];
            } else {
                _patient setVariable [QGVAR(AED_EKGDisplay), (([_rhythm, -1, 0] call FUNC(displayAEDMonitor_generateEKG)) select 0)];
            };
        };
    };
}; 

if (count (_patient getVariable [QGVAR(AED_PODisplay), []]) < AED_MONITOR_WIDTH || !(_patient getVariable [QGVAR(AED_Monitor_PulseOximeter_State), false])) then { // Initial
    if (_pulseOximeterState) then {
        _patient setVariable [QGVAR(AED_Monitor_PulseOximeter_State), true, true];
        if (_rhythm in [-1,0,5]) then {
            _patient setVariable [QGVAR(AED_PODisplay), (([_rhythm, _HRSpacing, 0, _saturation] call FUNC(displayAEDMonitor_generatePO)) select 0)];
        } else {
            if (_recentShock) then {
                _patient setVariable [QGVAR(AED_PODisplay), (([1, -1, 0, _saturation] call FUNC(displayAEDMonitor_generatePO)) select 0)];
            } else {
                _patient setVariable [QGVAR(AED_PODisplay), (([_rhythm, -1, 0, _saturation] call FUNC(displayAEDMonitor_generatePO)) select 0)];
            };
        };
    };
};

if (count (_patient getVariable [QGVAR(AED_CODisplay), []]) < AED_MONITOR_WIDTH || !(_patient getVariable [QGVAR(AED_Monitor_Capnograph_State), false])) then { // Initial
    if (_capnographState) then {
        _patient setVariable [QGVAR(AED_Monitor_Capnograph_State), true, true];
        if (_rhythm in [-1,0,5]) then {
            _patient setVariable [QGVAR(AED_CODisplay), (([_rhythm, _HRSpacing, 0, _etco2, _rr] call FUNC(displayAEDMonitor_generateCO)) select 0)];
        } else {
            if (_recentShock) then {
                _patient setVariable [QGVAR(AED_CODisplay), (([1, -1, 0, 0, 0] call FUNC(displayAEDMonitor_generateCO)) select 0)];
            } else {
                _patient setVariable [QGVAR(AED_CODisplay), (([_rhythm, -1, 0, _etco2, _rr] call FUNC(displayAEDMonitor_generateCO)) select 0)];
            };
        };
    };
};

// Sync up waveforms
private _monitorArray_EKG = _patient getVariable [QGVAR(AED_EKGDisplay), []];
private _monitorArray_PO = _patient getVariable [QGVAR(AED_PODisplay), []];
private _monitorArray_CO = _patient getVariable [QGVAR(AED_CODisplay), []];

for "_i" from 1 to (AED_MONITOR_WIDTH - 1) do { // TODO fix this
    if (_padsState) then {
        [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), 0, (_i - 1), (_monitorArray_EKG select (_i - 1)), (_monitorArray_EKG select _i), true] call FUNC(displayAEDMonitor_syncWaveform);
    } else {
        [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), 0, (_i - 1), -1, -1, false] call FUNC(displayAEDMonitor_syncWaveform);
    };
    if (_pulseOximeterState) then {
        [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), 1, (_i - 1), (_monitorArray_PO select (_i - 1)), (_monitorArray_PO select _i), true] call FUNC(displayAEDMonitor_syncWaveform);
    } else {
        [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), 1, (_i - 1), -1, -1, false] call FUNC(displayAEDMonitor_syncWaveform);
    };
    if (_capnographState) then {
        [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), 2, (_i - 1), (_monitorArray_CO select (_i - 1)), (_monitorArray_CO select _i), true] call FUNC(displayAEDMonitor_syncWaveform);
    } else {
        [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), 2, (_i - 1), -1, -1, false] call FUNC(displayAEDMonitor_syncWaveform);
    };
};

if (_patient getVariable [QGVAR(AEDMonitorDisplay_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _dlg = (uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]);

    private _padsState = [_patient, "", 1] call FUNC(hasAED);
    private _pulseOximeterState = [_patient, "", 2] call FUNC(hasAED);
    private _capnographState = [_patient, "", 4] call FUNC(hasAED);

    private _oxygenSaturation = _patient getVariable [QGVAR(AED_PulseOximeter_Display), -1];
    private _etco2 = _patient getVariable [QGVAR(AED_CO2_Display), -1];

    private _monitorUpdateStep = (_patient getVariable [QGVAR(AED_UpdateStep), (floor ((CBA_missionTime - (_patient getvariable [QGVAR(AED_StartTime), CBA_missionTime])) mod 6.2304 / 0.0354))]); // x1.18
    private _monitorArray_Offset = _patient getVariable [QGVAR(AED_Offset), 0];

    private _monitorArray_EKG = _patient getVariable [QGVAR(AED_EKGDisplay), []];
    private _monitorArray_PO = _patient getVariable [QGVAR(AED_PODisplay), []];
    private _monitorArray_CO = _patient getVariable [QGVAR(AED_CODisplay), []];

    private _monitorArray_EKGRefresh = _patient getVariable [QGVAR(AED_EKGRefreshDisplay), []];
    private _monitorArray_PORefresh = _patient getVariable [QGVAR(AED_PORefreshDisplay), []];
    private _monitorArray_CORefresh = _patient getVariable [QGVAR(AED_CORefreshDisplay), []];

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
    private _rr = GET_RESPIRATION_RATE(_patient);
    private _EKGRhythm = -5;
    private _PORhythm = -5;
    private _CORhythm = -5;
    private _EKGStepSpacing = 8;
    private _POStepSpacing = _EKGStepSpacing;
    private _COStepSpacing = _EKGStepSpacing;

    switch (true) do {
        case (alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull])): { // CPR
            if (_padsState) then {
                _EKGRhythm = -1;
            };
            if (_pulseOximeterState) then {
                _PORhythm = -1;
            };
            if (_capnographState) then {
                _CORhythm = -1;
            };
            _EKGStepSpacing = (60 / _hr) * AED_SPACING_MULTIPLIER;
            _POStepSpacing = _EKGStepSpacing;
            _COStepSpacing = _EKGStepSpacing;
        };
        case ([_patient, true] call FUNC(recentAEDShock)): { // After shock
            if (_padsState) then {
                _EKGRhythm = 1;
            };
            if (_pulseOximeterState) then {
                _PORhythm = 1;
            };
            if (_capnographState) then {
                _CORhythm = 1;
            };
            _EKGStepSpacing = 0;
            _POStepSpacing = 0;
            _COStepSpacing = 0;
        };
        case (_hr < 20): {
            _EKGStepSpacing = 0;
            _POStepSpacing = 0;
            _COStepSpacing = 0;
            if (_padsState) then {
                _EKGRhythm = _rhythmState;
                if (_EKGRhythm == 5) then { // PEA
                    _hr = [_patient] call FUNC(getEKGHeartRate);
                    _EKGStepSpacing = (60 / _hr) * AED_SPACING_MULTIPLIER;
                };
            };
            if (_pulseOximeterState) then {
                _PORhythm = 1;
            };
            if (_capnographState) then {
                _CORhythm = 1;
            };
        };
        case !(alive _patient): {
            if (_padsState) then {
                _EKGRhythm = 1;
            };
            if (_pulseOximeterState) then {
                _PORhythm = 1;
            };
            if (_capnographState) then {
                _CORhythm = 1;
            };
            _EKGStepSpacing = 0;
            _POStepSpacing = 0;
            _COStepSpacing = 0;
        };
        default { // Sinus
            if (_padsState) then {
                _EKGRhythm = _rhythmState;
            };
            if (_pulseOximeterState) then {
                if (_oxygenSaturation != -1) then {
                    _PORhythm = _rhythmState;
                } else {
                    _PORhythm = 1;
                };
            };
            if (_capnographState) then {
                if (_etco2 != -1) then {
                    _CORhythm = _rhythmState;
                } else {
                    _CORhythm = 1;
                };
            };
            _EKGStepSpacing = (60 / _hr) * AED_SPACING_MULTIPLIER;
            _POStepSpacing = _EKGStepSpacing;
            _COStepSpacing = _EKGStepSpacing;
        };
    };

    _EKGStepSpacing = 0 max (round(_EKGStepSpacing));
    _POStepSpacing = 0 max (round(_POStepSpacing));
    _COStepSpacing = 0 max (round(_COStepSpacing));

    private _connectedEKG = _patient getVariable [QGVAR(AED_Monitor_Pads_State), false] != _padsState;
    private _connectedPO = _patient getVariable [QGVAR(AED_Monitor_PulseOximeter_State), false] != _pulseOximeterState;
    private _connectedCO = _patient getVariable [QGVAR(AED_Monitor_Capnograph_State), false] != _capnographState;

    private _vitalsEKG = abs ((_patient getVariable [QGVAR(AED_Monitor_HR), 0]) - _hr) > 10;
    private _vitalsPO = abs ((_patient getVariable [QGVAR(AED_Monitor_OxygenSaturation), 0]) - _oxygenSaturation) > 6;
    private _vitalsCO = abs ((_patient getVariable [QGVAR(AED_Monitor_EtCO2), 0]) - _etco2) > 10;

    private _stepCondition = _monitorUpdateStep >= AED_MONITOR_LASTINDEX;
    private _rhythmChangeCondition = _EKGRhythm != _patient getVariable [QGVAR(AED_EKGRhythm), -2] || _PORhythm != _patient getVariable [QGVAR(AED_PORhythm), -2] || _CORhythm != _patient getVariable [QGVAR(AED_CORhythm), -2];
    private _vitalsCondition = _vitalsEKG || _vitalsPO || _vitalsCO;
    private _connectedCondition = _connectedEKG || _connectedPO || _connectedCO;
    private _listCondition = (count _monitorArray_EKGRefresh < AED_MONITOR_WIDTH) || (count _monitorArray_PORefresh < AED_MONITOR_WIDTH) || (count _monitorArray_CORefresh < AED_MONITOR_WIDTH);

    if (_stepCondition || {_vitalsCondition || {_rhythmChangeCondition || {_connectedCondition || {_listCondition}}}}) then { // Handle full pass / force update if rhythm changes/vitals change/device is disconnected
        _patient setVariable [QGVAR(AED_EKGRhythm), _EKGRhythm];
        _patient setVariable [QGVAR(AED_PORhythm), _PORhythm];
        _patient setVariable [QGVAR(AED_CORhythm), _CORhythm];

        private _generatedEKG = [_EKGRhythm, _EKGStepSpacing, _monitorArray_Offset] call FUNC(displayAEDMonitor_generateEKG);
        private _generatedPO = [_PORhythm, _POStepSpacing, _monitorArray_Offset, _oxygenSaturation] call FUNC(displayAEDMonitor_generatePO);
        private _generatedCO = [_CORhythm, _COStepSpacing, _monitorArray_Offset, _etco2, _rr] call FUNC(displayAEDMonitor_generateCO);

        _monitorArray_EKGRefresh = _generatedEKG select 0;
        _monitorArray_PORefresh = _generatedPO select 0;
        _monitorArray_CORefresh = _generatedCO select 0;

        private _safeArrayEKG = _generatedEKG select 1;
        private _safeArrayPO = _generatedPO select 1;
        private _safeArrayCO = _generatedCO select 1;

        if !(_stepCondition) then {
            private _rapidChange = _rhythmChangeCondition;

            if (_rapidChange) then {
                private _EKGArray = _monitorArray_EKG;
                {
                    private _index = _forEachIndex + 1 + _monitorUpdateStep;
                    if (_index < AED_MONITOR_WIDTH) then {
                        _EKGArray set [_index, _x];
                    };
                } forEach _monitorArray_EKGRefresh;

                _monitorArray_EKGRefresh = _EKGArray;

                private _POArray = _monitorArray_PO;
                {
                    private _index = _forEachIndex + 1 + _monitorUpdateStep;
                    if (_index < AED_MONITOR_WIDTH) then {
                        _POArray set [_index, _x];
                    };
                } forEach _monitorArray_PORefresh;

                _monitorArray_PORefresh = _POArray;

                private _COArray = _monitorArray_CO;
                {
                    private _index = _forEachIndex + 1 + _monitorUpdateStep;
                    if (_index < AED_MONITOR_WIDTH) then {
                        _COArray set [_index, _x];
                    };
                } forEach _monitorArray_CORefresh;

                _monitorArray_CORefresh = _COArray;

                _patient setVariable [QGVAR(AED_EKGRefreshDisplay), _monitorArray_EKGRefresh];
                _patient setVariable [QGVAR(AED_PORefreshDisplay), _monitorArray_PORefresh];
                _patient setVariable [QGVAR(AED_CORefreshDisplay), _monitorArray_CORefresh];
            } else {
                if (_connectedEKG || _vitalsEKG) then {
                    private _EKGArray = _monitorArray_EKG;

                    private _safeIndex = _monitorUpdateStep;

                    for "_i" from _monitorUpdateStep to AED_MONITOR_LASTINDEX do {
                        private _entry = (_safeArrayEKG select _i);

                        if (_entry) exitWith {
                            _safeIndex = _i;
                        };
                    };

                    for "_i" from _safeIndex to AED_MONITOR_LASTINDEX do {
                        private _refreshEntry = _monitorArray_EKGRefresh select (_i - _safeIndex);

                        _EKGArray set [_i, _refreshEntry];
                    };

                    _monitorArray_EKGRefresh = _EKGArray;

                    _patient setVariable [QGVAR(AED_EKGRefreshDisplay), _monitorArray_EKGRefresh];
                };

                if (_connectedPO || _vitalsPO) then {
                    private _POArray = _monitorArray_PO;

                    private _safeIndex = _monitorUpdateStep;

                    for "_i" from _monitorUpdateStep to AED_MONITOR_LASTINDEX do {
                        private _entry = (_safeArrayPO select _i);

                        if (_entry) exitWith {
                            _safeIndex = _i;
                        };
                    };

                    for "_i" from _safeIndex to AED_MONITOR_LASTINDEX do {
                        private _refreshEntry = _monitorArray_PORefresh select (_i - _safeIndex);

                        _POArray set [_i, _refreshEntry];
                    };

                    _monitorArray_PORefresh = _POArray;

                    _patient setVariable [QGVAR(AED_PORefreshDisplay), _monitorArray_PORefresh];
                };

                if (_connectedCO || _vitalsCO) then {
                    private _COArray = _monitorArray_CO;

                    private _safeIndex = _monitorUpdateStep;

                    for "_i" from _monitorUpdateStep to AED_MONITOR_LASTINDEX do {
                        private _entry = (_safeArrayCO select _i);

                        if (_entry) exitWith {
                            _safeIndex = _i;
                        };
                    };

                    for "_i" from _safeIndex to AED_MONITOR_LASTINDEX do {
                        private _refreshEntry = _monitorArray_CORefresh select (_i - _safeIndex);

                        _COArray set [_i, _refreshEntry];
                    };

                    _monitorArray_CORefresh = _COArray;

                    _patient setVariable [QGVAR(AED_CORefreshDisplay), _monitorArray_CORefresh];
                };
            };
        } else {
            _patient setVariable [QGVAR(AED_EKGRefreshDisplay), _monitorArray_EKGRefresh];
            _patient setVariable [QGVAR(AED_PORefreshDisplay), _monitorArray_PORefresh];
            _patient setVariable [QGVAR(AED_CORefreshDisplay), _monitorArray_CORefresh];
        };

        _patient setVariable [QGVAR(AED_Monitor_Pads_State), _padsState];
        _patient setVariable [QGVAR(AED_Monitor_PulseOximeter_State), _pulseOximeterState];
        _patient setVariable [QGVAR(AED_Monitor_Capnograph_State), _capnographState];
        _patient setVariable [QGVAR(AED_Monitor_OxygenSaturation), _oxygenSaturation];
        _patient setVariable [QGVAR(AED_Monitor_EtCO2), _etco2];
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

        if (_capnographState) then {
            ctrlShow [IDC_CO_Scale_Line_0, true];
            ctrlShow [IDC_CO_Scale_Line_1, true];
            ctrlShow [IDC_CO_Scale_Line_2, true];
            ctrlShow [IDC_CO_Scale_Line_3, true];
            ctrlShow [IDC_CO_Scale_Line_4, true];
            ctrlShow [IDC_CO_Scale_Line_5, true];
            ctrlShow [IDC_CO_Scale_Text_0, true];
            ctrlShow [IDC_CO_Scale_Text_50, true];
        } else {
            ctrlShow [IDC_CO_Scale_Line_0, false];
            ctrlShow [IDC_CO_Scale_Line_1, false];
            ctrlShow [IDC_CO_Scale_Line_2, false];
            ctrlShow [IDC_CO_Scale_Line_3, false];
            ctrlShow [IDC_CO_Scale_Line_4, false];
            ctrlShow [IDC_CO_Scale_Line_5, false];
            ctrlShow [IDC_CO_Scale_Text_0, false];
            ctrlShow [IDC_CO_Scale_Text_50, false];
        };
    };
}, 0, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AEDMonitorDisplay_PFH), _PFH];