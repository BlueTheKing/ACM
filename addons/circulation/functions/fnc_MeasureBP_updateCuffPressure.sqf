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

private _currentPressure = GVAR(MeasureBP_Gauge_Target);
private _newPressure = _currentPressure + _value;

if (_newPressure <= 0) then {
    _newPressure = 0;
} else {
    if (_newPressure >= 304) then {
        _newPressure = 304;
    };
};

GVAR(MeasureBP_Gauge_Target) = _newPressure;
GVAR(MeasureBP_Gauge_DialTarget) = _newPressure;