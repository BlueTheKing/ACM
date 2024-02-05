#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set pulse oximeter placement on patient hand
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", true] call AMS_breathing_fnc_setPulseOximeter;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", ["_state", true]];

private _hint = "placed";

if !(_state) then {
	_hint = "removed";
	[_medic, "AMS_PulseOximeter"] call ACEFUNC(common,addToInventory);
};

[_patient, "activity", "%1 %2 Pulse Oximeter", [[_medic, false, true] call ACEFUNC(common,getName), _hint]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(setPulseOximeterLocal), [_medic, _patient, _bodyPart, _state], _patient] call CBA_fnc_targetEvent;