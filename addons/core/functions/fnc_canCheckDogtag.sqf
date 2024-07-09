#include "..\script_component.hpp"
/*
 * Author: SzwedzikPL
 * Checks if dogtag can be checked.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * True if dogtag can be checked <BOOL>
 *
 * Example:
 * [player, cursorTarget] call ace_dogtags_fnc_canCheckDogtag // ACM_core_fnc_canCheckDogtag;
 *
 * Public: No
 */

params ["_medic", "_patient"];

// check if disabled for faction
if ([ACEGVAR(dogtags,disabledFactions) getVariable faction _patient] param [0, false]) exitWith {false};

!([_patient] call ACEFUNC(common,isAwake)) || (_patient getVariable [QGVAR(Lying_State), false]) || _medic == _patient || !(isPlayer _patient);