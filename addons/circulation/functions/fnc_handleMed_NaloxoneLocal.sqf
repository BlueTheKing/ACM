#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Naloxone effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_handleMed_NaloxoneLocal;
 *
 * Public: No
 */

params ["_patient"];

private _medicationArray = _patient getVariable [VAR_MEDICATIONS, []];
private _mitigatedArray = _patient getVariable [QGVAR(MitigatedMedication), []];

private _naloxoneEffect = 1;

[_patient, "Overdose_Opioid"] call FUNC(removeMedicationAdjustment);
private _removedAdjustments = [_patient, "Opioid", _naloxoneEffect] call FUNC(removeMedicationAdjustment);

{
    _mitigatedArray pushBack _x;
} forEach _removedAdjustments;

[{ // Naloxone time in system is 5 minutes
    params ["_patient"];

    if ([_patient, "Naloxone", false] call ACEFUNC(medical_status,getMedicationCount) == 0) then {
        private _mitigatedArray = _patient getVariable [QGVAR(MitigatedMedication), []];

        /*{
            _x params ["_medicationClassname", "_injectTime", "_timeToMaxEffect", "_maxTimeInSystem", "_hrAdjust", "_painAdjust", "_flowAdjust"];

            if (_injectTime + _maxTimeInSystem > CBA_missionTime) then {
                private _timeRemaining = CBA_missionTime - _injectTime;
                private _newTimeToMaxEffect = 2;

                if !(_timeRemaining < _timeToMaxEffect) then {
                    _newTimeToMaxEffect = _timeToMaxEffect - (_maxTimeInSystem - _timeRemaining);
                };

                [_patient, _medicationClassname, _newTimeToMaxEffect, _timeRemaining, _hrAdjust, _painAdjust, _flowAdjust] call ACEFUNC(medical_status,addMedicationAdjustment);
            };
        } forEach _mitigatedArray;*/

        _patient setVariable [QGVAR(MitigatedMedication), [], true];
    };
}, [_patient], 300] call CBA_fnc_waitAndExecute;