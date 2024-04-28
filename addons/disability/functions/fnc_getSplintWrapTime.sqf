#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get time required to wrap splint
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * Time to wrap <INT>
 *
 * Example:
 * [player, cursorTarget] call ACM_disability_fnc_getSplintWrapTime;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _time = EGVAR(core,treatmentTimeWrapSplint);

if (_medic isEqualTo _patient) then {
    _time = _time * 2;
};

_time