#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if eyes can be washed on patient.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_canWashEyes;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(Chemical_CS_WasExposed), false]) exitWith {true};
if ((_patient getVariable [QGVAR(Chemical_Chlorine_WasExposed), false]) && !(_patient getVariable [QGVAR(Chemical_Chlorine_Blindness), true])) exitWith {true};
if ((_patient getVariable [QGVAR(Chemical_Lewisite_WasExposed), false]) && !(_patient getVariable [QGVAR(Chemical_Lewisite_Blindness), true])) exitWith {true};

false;