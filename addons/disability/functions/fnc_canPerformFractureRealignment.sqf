#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if fracture realignment can be performed.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * Can perform fracture realignment <BOOL>
 *
 * Example:
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_canPerformFractureRealignment;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

if !(GVAR(enableFractureSeverity)) exitWith {false};

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

(((_patient getVariable [QGVAR(Fracture_State), [0,0,0,0,0,0]]) select _partIndex) > 0) && (GET_SPLINTS(_patient) select _partIndex) == 0;