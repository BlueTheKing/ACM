#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle TXA effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_handleMed_TXALocal;
 *
 * Public: No
 */

params ["_patient"];

[QGVAR(handleCoagulationPFH), [_patient, true], _patient] call CBA_fnc_targetEvent;
[QGVAR(handleIBCoagulationPFH), [_patient, true], _patient] call CBA_fnc_targetEvent;