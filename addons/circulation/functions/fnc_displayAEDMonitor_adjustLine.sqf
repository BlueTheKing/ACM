#include "..\script_component.hpp"
#include "..\defines.hpp"
/*
 * Author: Blue
 * Adjusts set monitor line in current step
 *
 * Arguments:
 * 0: Dialog Control <DISPLAY>
 * 1: Line Type <NUMBER>
 	* 0: EKG
	* 1: Pulse Oximeter
	* 2: EtCO2
 * 2: Control Index <NUMBER>
 * 3: Previous height from array <NUMBER>
 * 4: Target height from array <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), 0, 0, 0, 10] call AMS_circulation_fnc_displayAEDMonitor_adjustLine;
 *
 * Public: No
 */

params ["_dlg", "_type", "_ctrlIndex", "_previousHeight", "_targetHeight"];

private _dashed = (_targetHeight > 99 || _targetHeight < -99);

_ctrlIndex = _ctrlIndex - 1;

private _lineIDC = IDC_EKG_LINE_0 + _type * 2000;
private _ctrlLine = _dlg displayCtrl (_ctrlIndex + _lineIDC);
private _ctrlDot = _dlg displayCtrl (_ctrlIndex + _lineIDC + 1000);

if !(_dashed) then {
    switch (_type) do {
        case 1: {
            _previousHeight = _previousHeight + 160;
            _targetHeight = _targetHeight + 160;
        };
        case 2: {};
    };

    _ctrlLine ctrlSetPosition [(ctrlPosition _ctrlLine select 0), AMS_pxToScreen_Y(EKG_Line_Y(_previousHeight)), (ctrlPosition _ctrlLine select 2), AMS_pxToScreen_H((_targetHeight - _previousHeight))];
    _ctrlLine ctrlCommit 0;

    if (abs (_previousHeight - _targetHeight) < 0.8) then {
        _ctrlDot ctrlSetPosition [(ctrlPosition _ctrlDot select 0), AMS_pxToScreen_Y(EKG_Line_Y(_previousHeight)), (ctrlPosition _ctrlDot select 2), (ctrlPosition _ctrlDot select 3)];
        _ctrlDot ctrlCommit 0;
        _ctrlDot ctrlShow true;
    } else {
        _ctrlDot ctrlShow false;
    };

    _ctrlLine ctrlShow true;
} else {
    private _offset = 0;
    switch (_type) do {
        case 1: {
            _offset = 160;
        };
        case 2: {};
    };
    if (_targetHeight > 99) then {
        _ctrlDot ctrlSetPosition [(ctrlPosition _ctrlDot select 0), AMS_pxToScreen_Y(EKG_Line_Y(_offset)), (ctrlPosition _ctrlDot select 2), (ctrlPosition _ctrlDot select 3)];
        _ctrlDot ctrlCommit 0;
        _ctrlDot ctrlShow true;
    } else {
        _ctrlDot ctrlShow false;
    };
};

private _forwardLineIndex = _ctrlIndex + 4;

if (_forwardLineIndex >= AED_MONITOR_WIDTH) then {
    _forwardLineIndex = _forwardLineIndex - AED_MONITOR_WIDTH;
};

(_dlg displayCtrl (_forwardLineIndex + _lineIDC + 1000)) ctrlShow false;
(_dlg displayCtrl (_forwardLineIndex + _lineIDC)) ctrlShow false;