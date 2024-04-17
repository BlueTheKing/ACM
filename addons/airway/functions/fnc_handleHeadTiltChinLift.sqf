#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle head tilt-chin lift
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_airway_fnc_handleHeadTiltChinLift;
 *
 * Public: No
 */

params ["_medic", "_patient"];

[{
	params ["_medic", "_patient"];

	_patient call ACEFUNC(medical_status,isBeingDragged) || _patient call ACEFUNC(medical_status,isBeingCarried) || !(_patient getVariable [QGVAR(HeadTilt_State), false]) || !(objectParent _patient isEqualTo objectParent _medic) || (_patient distance _medic) > 3;
	
}, {
	params ["_medic", "_patient"];

	if (_patient getVariable [QGVAR(HeadTilt_State), false]) then {
		[_medic, _patient, false] call FUNC(setHeadTiltChinLift);
	};
}, [_medic, _patient], 3600] call CBA_fnc_waitUntilAndExecute;