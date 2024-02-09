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
 * [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), player, 0] call AMS_circulation_fnc_displayAEDMonitor_updateStep;
 *
 * Public: No
 */

params ["_dlg", "_patient", "_updateStep"];

private _monitorArray_EKGRefresh = _patient getVariable [QGVAR(AEDMonitor_EKGRefreshDisplay), []];
private _monitorArray_PORefresh = _patient getVariable [QGVAR(AEDMonitor_PORefreshDisplay), []];

// EKG
private _monitorArray_EKG = _patient getVariable [QGVAR(AEDMonitor_EKGDisplay), []];
_monitorArray_EKG set [_updateStep, _monitorArray_EKGRefresh select _updateStep];
_patient setVariable [QGVAR(AEDMonitor_EKGDisplay), _monitorArray_EKG];

// Pulse Oximeter
private _monitorArray_PO = _patient getVariable [QGVAR(AEDMonitor_PODisplay), []];
_monitorArray_PO set [_updateStep, _monitorArray_PORefresh select _updateStep];
_patient setVariable [QGVAR(AEDMonitor_PODisplay), _monitorArray_PO];

private _previousIndex = _updateStep - 1;

[_dlg, 0, _updateStep, (_monitorArray_EKGRefresh select _previousIndex), (_monitorArray_EKGRefresh select _updateStep)] call FUNC(displayAEDMonitor_adjustLine);
[_dlg, 1, _updateStep, (_monitorArray_PORefresh select _previousIndex), (_monitorArray_PORefresh select _updateStep)] call FUNC(displayAEDMonitor_adjustLine);