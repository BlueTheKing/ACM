#include "..\script_component.hpp"
/*
 * Author: Blue
 * Generates new fresh blood entry based on patient, and returns relevant ID.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Volume <NUMBER>
 *
 * Return Value:
 * 0: Fresh Blood Entry ID <NUMBER>
 *
 * Example:
 * [player] call ACM_circulation_fnc_generateFreshBloodEntry;
 *
 * Public: No
 */

params ["_patient", "_volume"];

private _collectionTime = CBA_missionTime;
private _bloodType = [_patient] call FUNC(generateBloodType);

private _freshBloodlist = (missionNamespace getVariable [QGVAR(FreshBloodList), createHashMap]);

private _id = count _freshBloodlist;

if (_id > 999) exitWith {0}; // uh oh

_freshBloodlist set [_id, [_patient,_volume,_bloodType,_collectionTime]];

missionNamespace setVariable [QGVAR(FreshBloodList), _freshBloodlist, true];

_id;