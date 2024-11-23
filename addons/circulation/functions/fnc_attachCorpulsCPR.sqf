#include "..\script_component.hpp"
/*
 * Author: Miss Heda
 * Attach Corpuls CPR
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_circulation_fnc_attachCorpulsCPR;
 *
 * Public: No
 */

params ["_medic", "_patient"];

removeBackpackGlobal _medic;
_patient addBackpackGlobal 'ACM_Corpuls_CPR';