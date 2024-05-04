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

private _TXAEffect = _patient getVariable [QGVAR(TXA_Effect), 0];

_patient setVariable [QGVAR(TXA_Effect), ((_TXAEffect + 1) min 2)];

[QGVAR(handleCoagulationPFH), [_patient, true], _patient] call CBA_fnc_targetEvent;
[QGVAR(handleIBCoagulationPFH), [_patient, true], _patient] call CBA_fnc_targetEvent;

[{
    params ["_patient"];

    [_patient, "TXA_Vial", false] call ACEFUNC(medical_status,getMedicationCount) < 0.1;
    
}, {
    params ["_patient"];

    private _TXAEffect = _patient getVariable [QGVAR(TXA_Effect), 0];

    _patient setVariable [QGVAR(TXA_Effect), ((_TXAEffect - 1) max 0)];
}, [_patient], 420] call CBA_fnc_waitUntilAndExecute;