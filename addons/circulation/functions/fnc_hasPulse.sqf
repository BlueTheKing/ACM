#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return if patient has normal pulse
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Palpable? <BOOL>
 *
 * Return Value:
 * Has Pulse? <BOOL>
 *
 * Example:
 * [player] call ACM_circulation_fnc_hasPulse;
 *
 * Public: No
 */

params ["_patient", ["_palpable", false]];

if ([_patient] call EFUNC(core,cprActive)) exitWith {true};

if (!(alive _patient) || [_patient] call FUNC(recentAEDShock) || !(GET_CIRCULATIONSTATE(_patient)) || IN_CRDC_ARRST(_patient)) exitWith {false};

if (_palpable) exitWith {!(IN_CRITICAL_STATE(_patient))};

true;