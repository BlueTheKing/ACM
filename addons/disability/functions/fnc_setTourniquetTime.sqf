#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set time of application of tourniquet on body part.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_setTourniquetTime;
 *
 * Public: No
 */

params ["_patient", "_bodyPart"];

private _partIndex = ALL_BODY_PARTS find toLower _bodyPart;
private _tourniquetsDisplay = _patient getVariable [QGVAR(Tourniquet_Time), [0,0,0,0,0,0]];
private _tourniquetsTime = _patient getVariable [QGVAR(Tourniquet_ApplyTime), [-1,-1,-1,-1,-1,-1]];

_tourniquetsDisplay set [_partIndex, ([dayTime, "HH:MM"] call BIS_fnc_timeToString)];
_tourniquetsTime set [_partIndex, CBA_missionTime];

_patient setVariable [QGVAR(Tourniquet_Time), _tourniquetsDisplay, true];
_patient setVariable [QGVAR(Tourniquet_ApplyTime), _tourniquetsTime, true];