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

private _fnc_syncLine = { // TODO move this to a function
    params ["_dlg", "_type", "_ctrlIndex", "_previousHeight", "_targetHeight"];

    _ctrlIndex = _ctrlIndex - 1;

    private _lineIDC = IDC_EKG_LINE_0 + _type * 2000;

    switch (_type) do {
        case 1: {
            _previousHeight = _previousHeight + 160;
            _targetHeight = _targetHeight + 160;
        };
        case 2: {};
    };

    private _ctrlLine = _dlg displayCtrl (_ctrlIndex + _lineIDC);
    private _ctrlDot = _dlg displayCtrl (_ctrlIndex + _lineIDC + 1000);
    
    _ctrlLine ctrlSetPosition [(ctrlPosition _ctrlLine select 0), AMS_pxToScreen_Y(EKG_Line_Y(_previousHeight)), (ctrlPosition _ctrlLine select 2), AMS_pxToScreen_H((_targetHeight - _previousHeight))];
    _ctrlLine ctrlCommit 0;

    if (abs (_previousHeight - _targetHeight) < 0.8) then {
        _ctrlDot ctrlSetPosition [(ctrlPosition _ctrlDot select 0), AMS_pxToScreen_Y(EKG_Line_Y(_previousHeight)), (ctrlPosition _ctrlDot select 2), (ctrlPosition _ctrlDot select 3)];
        _ctrlDot ctrlCommit 0;
        _ctrlDot ctrlShow true;
    } else {
        _ctrlDot ctrlShow false;
    };
};

private _ekgDisplay = _patient getVariable [QGVAR(AED_EKGDisplay), []];

uiNamespace setVariable [QGVAR(AED_DLG),(findDisplay IDC_LIFEPAK_MONITOR)];

if (count (_ekgDisplay) < AED_MONITOR_WIDTH) then {
    _ekgDisplay resize [AED_MONITOR_WIDTH, 0];
    _patient setVariable [QGVAR(AED_EKGDisplay), _ekgDisplay];
} else {
    private _monitorArray_EKG = _patient getVariable [QGVAR(AED_EKGDisplay), []];
    private _monitorArray_PO = _patient getVariable [QGVAR(AED_PODisplay), []];

    for "_i" from 1 to (AED_MONITOR_WIDTH - 1) do {
        //[(uiNamespace getVariable [QGVAR(AED_DLG),displayNull]), 0, _i, (_monitorArray_EKG select (_i - 1)), (_monitorArray_EKG select _i)] call _fnc_syncLine;
        //[(uiNamespace getVariable [QGVAR(AED_DLG),displayNull]), 1, _i, (_monitorArray_PO select (_i - 1)), (_monitorArray_PO select _i)] call _fnc_syncLine;
    };
};

if (_patient getVariable [QGVAR(AEDMonitorDisplay_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _dlg = (uiNamespace getVariable [QGVAR(AED_DLG),displayNull]);

    private _monitorUpdateStep = _patient getVariable [QGVAR(AED_UpdateStep), 0];
    private _monitorArray_Offset = _patient getVariable [QGVAR(AED_Offset), 0];

    private _monitorArray_EKGRefresh = _patient getVariable [QGVAR(AED_EKGRefreshDisplay), []];
    private _monitorArray_PORefresh = _patient getVariable [QGVAR(AED_PORefreshDisplay), []];

    private _timeToExpire = ((AED_MONITOR_WIDTH - 1) - _monitorUpdateStep) * 0.03;

    if (isNull _dlg && ((_patient getVariable [QGVAR(AED_RefreshTime), -1]) + _timeToExpire < CBA_missionTime)) exitWith {
        systemchat "kill pfh";
        //_patient setVariable [QGVAR(AED_EKGDisplay), _monitorArray_EKGRefresh, true];
        //_patient setVariable [QGVAR(AED_PODisplay), _monitorArray_PORefresh, true];

        _patient setVariable [QGVAR(AED_UpdateStep), 0, true];
        _patient setVariable [QGVAR(AED_Offset), 0, true];
        
        _patient setVariable [QGVAR(AEDMonitorDisplay_PFH), -1];
        
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private _hr = GET_HEART_RATE(_patient);
    private _rhythm = _patient getVariable [QGVAR(CardiacArrest_RhythmState), 0];
    private _stepSpacing = 8;

    if (_patient getVariable [QGVAR(AED_Placement_Pads), false]) then {
        if (IN_CRDC_ARRST(_patient)) then {
            if (alive (_patient getVariable [QACEGVAR(medical,CPR_provider), objNull])) then {
                _rhythm = -1;
            };

            switch (_rhythm) do {
                case 1: { };
                case 2: { };
                case 3: { };
                default {
                    _stepSpacing = 640 / _hr;
                };
            };
        } else {
            _stepSpacing = 640 / _hr;
        };
    } else {
        _rhythm = -5;
        _monitorArray_Offset = 0;
    };

    _stepSpacing = 0 max (round(_stepSpacing));

    if (_monitorUpdateStep >= (AED_MONITOR_WIDTH - 1) || (_rhythm != _patient getVariable [QGVAR(AED_EKGRhythm), -1]) || {(count _monitorArray_EKGRefresh < AED_MONITOR_WIDTH)}) then { // 
        _patient setVariable [QGVAR(AED_RefreshTime), CBA_missionTime, true];
        _patient setVariable [QGVAR(AED_EKGRhythm), _rhythm, true];

        _monitorArray_EKGRefresh = [_rhythm, _stepSpacing, _monitorArray_Offset] call FUNC(displayAEDMonitor_generateEKG);
        _patient setVariable [QGVAR(AED_EKGRefreshDisplay), _monitorArray_EKGRefresh];

        _monitorArray_PORefresh = [_rhythm, _stepSpacing, _monitorArray_Offset, (_patient getVariable [QGVAR(AED_PulseOximeter_Display), 0])] call FUNC(displayAEDMonitor_generatePO);
        _patient setVariable [QGVAR(AED_PORefreshDisplay), _monitorArray_PORefresh];

        _monitorArray_Offset = _monitorArray_Offset + round (random [-1.4, 0, 1.4]);
        if (_monitorArray_Offset > 22) then {
            _monitorArray_Offset = 0;
        };
        
        _patient setVariable [QGVAR(AED_Offset), _monitorArray_Offset, true];
    };

    if !(isNull _dlg) then {
        if ((GVAR(EKG_Tick) + 0.03) < CBA_missionTime) then {
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