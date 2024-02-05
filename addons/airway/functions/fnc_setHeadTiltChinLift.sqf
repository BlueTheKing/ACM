#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform head tilt-chin lift manuever on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, true] call AMS_airway_fnc_setHeadTiltChinLift;
 *
 * Public: No
 */

params ["_medic", "_patient", "_state"];

_patient setVariable [QGVAR(HeadTilt_State), _state, true];
[_patient] call FUNC(updateAirwayState);

private _hint = "Performing head tilt-chin lift<br />Stay close to the patient";

if (_state) then {
    [QGVAR(handleHeadTiltChinLift), [_medic, _patient], _patient] call CBA_fnc_targetEvent;

    [_patient, "activity", "%1 started perfoming head tilt-chin lift", [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
} else {
    _hint = "Head tilt-chin lift cancelled";
};

[_hint, 1.5, _medic] call ACEFUNC(common,displayTextStructured);