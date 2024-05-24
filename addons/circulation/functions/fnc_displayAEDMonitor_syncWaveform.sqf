#include "..\script_component.hpp"
#include "..\Defibrillator_defines.hpp"
/*
 * Author: Blue
 * Sync AED monitor waveform step.
 *
 * Arguments:
 * 0: Dialog Control <DISPLAY>
 * 1: Waveform Type <NUMBER>
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
 * [(uiNamespace getVariable [QGVAR(AEDMonitor_DLG),displayNull]), 0, 0, 0, 10] call ACM_circulation_fnc_displayAEDMonitor_syncWaveform;
 *
 * Public: No
 */

params ["_dlg", "_type", "_ctrlIndex", "_previousHeight", "_targetHeight", ["_connected", true]];

private _lineIDC = IDC_EKG_LINE_0 + _type * 2000;
private _ctrlLine = _dlg displayCtrl (_ctrlIndex + _lineIDC);
private _ctrlDot = _dlg displayCtrl (_ctrlIndex + _lineIDC + 1000);

private _minAngle = 0.8;

if (_connected) then {
    switch (_type) do {
        case 1: {
            _previousHeight = _previousHeight + AED_PO_Y_SPACING;
            _targetHeight = _targetHeight + AED_PO_Y_SPACING;
        };
        case 2: {
            _previousHeight = _previousHeight + AED_CO_Y_SPACING;
            _targetHeight = _targetHeight + AED_CO_Y_SPACING;
            _minAngle = 0.75;
        };
    };

    _ctrlLine ctrlSetPosition [(ctrlPosition _ctrlLine select 0), ACM_AED_pxToScreen_Y(EKG_Line_Y(_previousHeight)), (ctrlPosition _ctrlLine select 2), ACM_AED_pxToScreen_H((_targetHeight - _previousHeight))];
    _ctrlLine ctrlCommit 0;
    _ctrlLine ctrlShow true;

    if (abs (_previousHeight - _targetHeight) < _minAngle) then {
        _ctrlDot ctrlSetPosition [(ctrlPosition _ctrlDot select 0), ACM_AED_pxToScreen_Y(EKG_Line_Y(_previousHeight)), (ctrlPosition _ctrlDot select 2), (ctrlPosition _ctrlDot select 3)];
        _ctrlDot ctrlCommit 0;
        _ctrlDot ctrlShow true;
    } else {
        _ctrlDot ctrlShow false;
    };
} else {
    _ctrlLine ctrlShow false;

    _ctrlDot ctrlShow ([true,false] select ((_ctrlIndex mod 4) in [0,1]));
};