#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set detector alarm is enabled.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, true] call ACM_CBRN_fnc_detector_setAlarm;
 *
 * Public: No
 */

params ["_unit", "_state"];

_unit setVariable [QGVAR(Detector_Alarm_State), _state, true];

[([LLSTRING(ChemicalDetector_AlarmDisabled), LLSTRING(ChemicalDetector_AlarmEnabled)] select _state), 2, _unit] call ACEFUNC(common,displayTextStructured);