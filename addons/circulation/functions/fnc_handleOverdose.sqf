#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle medication overdose
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Medication Classname <STRING>
 * 2: Max Medication Dose <NUMBER>
 * 3: Max Dose Deviation <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, "Morphine"] call ACM_circulation_fnc_handleOverdose;
 *
 * Public: No
 */

params ["_patient", "_classname", "_maxDose", "_doseDeviation"];

private _toxicThreshold = _maxDose;
private _fatalThreshold = _maxDose + _doseDeviation;

private _handleOverdoseEffect = {
    params ["_patient", "_classname"];

    switch (_classname) do {
        case "Ketamine_IM";
        case "Ketamine": {
            [_patient, "Overdose_Ketamine", 60, 300, (random [-20, -35, -40]), 0, 0, ACM_ROUTE_IM, 90, 0, (random [-0.9, -0.95, -1]), (random [-0.01, -0.05, -0.1]), 1] call ACEFUNC(medical_status,addMedicationAdjustment);
        };
        case "Lidocaine": {
            [_patient, "Overdose_Lidocaine", 60, 360, (random [-40, -45, -50]), 0, 0, ACM_ROUTE_IM, 90, 0, (random [-0.9, -0.95, -1]), 0, 1] call ACEFUNC(medical_status,addMedicationAdjustment);
        };
        case "Morphine";
        case "Morphine_IV": {
            [_patient, "Overdose_Opioid", 60, 360, (random [-10, -15, -20]), 0, 0, ACM_ROUTE_IM, 120, (random [-40, -45, -50]), (random [-0.9, -0.95, -1]), (random [-0.01, -0.05, -0.1]), 1] call ACEFUNC(medical_status,addMedicationAdjustment);
        };
        case "Penthrox": {
            [_patient, "Overdose_Penthrox", 30, 300, (random [-10, -15, -20]), 0, 0, ACM_ROUTE_IM, 60, (random [-40, -45, -50]), (random [-0.9, -0.95, -1]), (random [-0.01, -0.05, -0.1]), 1] call ACEFUNC(medical_status,addMedicationAdjustment);
        };
    };
};

[{
    params ["_patient", "_classname", "_fatalThreshold"];

    [_patient, _classname, false] call ACEFUNC(medical_status,getMedicationCount) > _fatalThreshold;
}, {
    params ["_patient", "_classname", "_fatalThreshold", "_handleOverdoseEffect"];

    if ([_patient, _classname, false] call ACEFUNC(medical_status,getMedicationCount) > _fatalThreshold) then {
        [_patient, _classname] call _handleOverdoseEffect;
    };
}, [_patient, _classname, _fatalThreshold, _handleOverdoseEffect], 3600] call CBA_fnc_waitUntilAndExecute;