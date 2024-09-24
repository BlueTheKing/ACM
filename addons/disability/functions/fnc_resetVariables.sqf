#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset disability variables to default values
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_disability_fnc_resetVariables;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(Tourniquet_Time), [0,0,0,0,0,0], true];
_patient setVariable [QGVAR(Tourniquet_ApplyTime), [-1,-1,-1,-1,-1,-1], true];

_patient setVariable [VAR_SPLINTS, DEFAULT_SPLINT_VALUES, true];

_patient setVariable [VAR_TOURNIQUET_NECROSIS, DEFAULT_TOURNIQUET_NECROSIS];
_patient setVariable [VAR_TOURNIQUET_NECROSIS_T, DEFAULT_TOURNIQUET_NECROSIS];
_patient setVariable [QGVAR(TourniquetEffects_PFH), -1];