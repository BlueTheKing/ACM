#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset breathing variables to default values (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_breathing_fnc_resetVariables;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(ChestInjury_State), false, true];

_patient setVariable [QGVAR(Pneumothorax_State), 0, true];
_patient setVariable [QGVAR(TensionPneumothorax_State), false, true];

_patient setVariable [QGVAR(Hemothorax_State), 0, true];
_patient setVariable [QGVAR(Hemothorax_Fluid), 0, true];

_patient setVariable [QGVAR(ChestSeal_State), false, true];

_patient setVariable [QGVAR(Thoracostomy_State), nil, true];

_patient setVariable [QGVAR(PulseOximeter_Display), [[0,0],[0,0]], true]; 
_patient setVariable [QGVAR(PulseOximeter_Placement), [false,false], true];
_patient setVariable [QGVAR(PulseOximeter_PFH), -1];
_patient setVariable [QGVAR(PulseOximeter_LastSync), [-1,-1]];

_patient setVariable [QGVAR(Hardcore_Pneumothorax), false, true];

[_patient, true] call FUNC(updateBreathingState);

_patient setVariable [QGVAR(BVM_provider), objNull, true];
_patient setVariable [QGVAR(BVM_Medic), objNull, true];
_patient setVariable [QGVAR(isUsingBVM), false, true];

_patient setVariable [QGVAR(BVM_ConnectedOxygen), false, true];

_patient setVariable [QGVAR(BVM_lastBreath), -1, true];

_patient setVariable [QGVAR(RespirationRate), (ACM_TARGETVITALS_RR(_patient)), true];