#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return if AED shouldn't be playing any alarms/beeps (recent shock/giving advice/alarms turned off)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Is Silent <BOOL>
 *
 * Example:
 * [player] call ACM_circulation_fnc_AED_IsSilent;
 *
 * Public: No
 */

params ["_patient"];

([_patient, true] call FUNC(recentAEDShock)) || (_patient getVariable [QGVAR(AED_MuteAlarm), false]) || (_patient getVariable [QGVAR(AED_Analyze_Busy), false]) || (_patient getVariable [QGVAR(AED_TrackingCPR), false]);