#include "..\script_component.hpp"
/*
 * Author: Blue
 * Begin measuring BP with AED pressure cuff
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call AMS_circulation_fnc_AED_MeasureBP;
 *
 * Public: No
 */

params ["_medic", "_patient"];

_patient setVariable [QGVAR(AED_PressureCuffBusy), true, true];
_patient setVariable [QGVAR(AED_PressureCuff_Measure), [0,0]];

[{
    params ["_medic", "_patient"];

    !([_medic, _patient, "", 3] call FUNC(hasAED));
}, {}, [_medic, _patient], (4 + (random 4)), 
{
    params ["", "_patient"];

    private _systolic = 0;
    private _diastolic = 0;

    private _pressureCuffPlacement = _patient getVariable [QGVAR(AED_Placement_PressureCuff), -1];

    if !(HAS_TOURNIQUET_APPLIED_ON(_patient,_pressureCuffPlacement)) then {
        private _bp = GET_BLOOD_PRESSURE(_patient); // backwards

        _systolic = _bp select 1;
        _diastolic = _bp select 0;
    };

    _patient setVariable [QGVAR(AED_PressureCuff_Measure), [_systolic, _diastolic]];
}] call CBA_fnc_waitUntilAndExecute;

[{
    params ["_medic", "_patient"];

    !([_medic, _patient, "", 3] call FUNC(hasAED));
}, {}, [_medic, _patient], 10, 
{
    params ["", "_patient"];

    _patient setVariable [QGVAR(AED_PressureCuffBusy), false, true];

    private _measuredBP = _patient getVariable [QGVAR(AED_PressureCuff_Measure), [0,0]];
    _patient setVariable [QGVAR(AED_NIBP_Display), [(_measuredBP select 0), (_measuredBP select 1)], true];
    _patient setVariable [QGVAR(AED_PressureCuff_Measure), [0,0]];
}] call CBA_fnc_waitUntilAndExecute;