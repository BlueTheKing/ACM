#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle vitals graphs during step update
 *
 * Arguments:
 * 0: Dialog Control <DISPLAY>
 * 1: Patient <OBJECT>
 * 2: Step in array <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), player, 0] call ACM_circulation_fnc_displayAEDMonitor_updateStep;
 *
 * Public: No
 */

params ["_dlg", "_patient", "_updateStep"];

private _monitorArray_EKGRefresh = _patient getVariable [QGVAR(AED_EKGRefreshDisplay), []];
private _monitorArray_PORefresh = _patient getVariable [QGVAR(AED_PORefreshDisplay), []];
private _monitorArray_CORefresh = _patient getVariable [QGVAR(AED_CORefreshDisplay), []];

// EKG
private _monitorArray_EKG = _patient getVariable [QGVAR(AED_EKGDisplay), []];
_monitorArray_EKG set [_updateStep, _monitorArray_EKGRefresh select _updateStep];
_patient setVariable [QGVAR(AED_EKGDisplay), _monitorArray_EKG];

private _padsState = [_patient, "", 1] call FUNC(hasAED);

// Pulse Oximeter
private _monitorArray_PO = _patient getVariable [QGVAR(AED_PODisplay), []];
_monitorArray_PO set [_updateStep, _monitorArray_PORefresh select _updateStep];
_patient setVariable [QGVAR(AED_PODisplay), _monitorArray_PO];

private _pulseOximeterState = [_patient, "", 2] call FUNC(hasAED);

// Capnograph
private _monitorArray_CO = _patient getVariable [QGVAR(AED_CODisplay), []];
_monitorArray_CO set [_updateStep, _monitorArray_CORefresh select _updateStep];
_patient setVariable [QGVAR(AED_CODisplay), _monitorArray_CO];

private _capnographState = [_patient, "", 4] call FUNC(hasAED);

private _previousIndex = _updateStep - 1;

[_dlg, 0, _updateStep, (_monitorArray_EKGRefresh select _previousIndex), (_monitorArray_EKGRefresh select _updateStep), _padsState] call FUNC(displayAEDMonitor_adjustWaveform);
[_dlg, 1, _updateStep, (_monitorArray_PORefresh select _previousIndex), (_monitorArray_PORefresh select _updateStep), _pulseOximeterState] call FUNC(displayAEDMonitor_adjustWaveform);
[_dlg, 2, _updateStep, (_monitorArray_CORefresh select _previousIndex), (_monitorArray_CORefresh select _updateStep), _capnographState] call FUNC(displayAEDMonitor_adjustWaveform);