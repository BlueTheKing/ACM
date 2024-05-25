#include "..\script_component.hpp"
#include "..\MeasureBP_defines.hpp"
/*
 * Author: Blue
 * Handle button press
 *
 * Arguments:
 * 0: Pressed Control <DISPLAY>
 * 1: Button Pressed <NUMBER>
    * 0: LMB
    * 1: RMB
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call ACM_circulation_fnc_MeasureBP_press;
 *
 * Public: No
 */

params ["_control", "_button"];

private _value = 0;

if ((ctrlIDC _control) == IDC_MEASUREBP_BUTTON_BULB) then {
    if (_button == 0) then {
        _value = 50;
    } else {
        _value = 30;
    };
} else {
    if (_button == 0) then {
        _value = -10;
    } else {
        _value = -2;
    };
};

[_value] call FUNC(MeasureBP_updateCuffPressure);