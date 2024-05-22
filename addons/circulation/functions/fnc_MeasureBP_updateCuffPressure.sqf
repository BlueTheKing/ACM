#include "..\script_component.hpp"
#include "..\MeasureBP_defines.hpp"
/*
 * Author: Blue
 * Update pressure cuff pressure
 *
 * Arguments:
 * 0: Update Value <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 10] call ACM_circulation_fnc_MeasureBP_updateCuffPressure;
 *
 * Public: No
 */

params ["_value"];

private _currentPressure = GVAR(MeasureBP_Gauge_Pressure);
private _newPressure = _currentPressure + _value;

if (_newPressure <= 0) then {
    _newPressure = 0;
} else {
    if (_newPressure >= 300) then {
        _newPressure = 300;
    };
};

GVAR(MeasureBP_Gauge_Pressure) = _newPressure;

private _offset = 0;

if (_newPressure >= 20) then {
    _offset = round(linearConversion [20, 300, _newPressure, 4, 36, true]);
} else {
    _offset = round(linearConversion [0, 20, _newPressure, 0, 4, true]);
};

GVAR(MeasureBP_Gauge_Offset) = _offset;

GVAR(MeasureBP_Gauge_Target) = _newPressure + _offset + 90;