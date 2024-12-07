#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle fatal vitals of patient (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_handleFatalVitals;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(CriticalVitals_State), false] || IN_CRDC_ARRST(_patient) || !(alive _patient)) exitWith {};

if (GET_BLOOD_VOLUME(_patient) > BLOOD_VOLUME_CLASS_4_HEMORRHAGE && !(_patient getVariable [QGVAR(CriticalVitals_Passed), false])) exitWith {
    [_patient] call FUNC(handleCriticalVitals);
};
[QACEGVAR(medical,FatalVitals), _patient] call CBA_fnc_localEvent;