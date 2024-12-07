#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get Mean Arterial Pressure of patient
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Mean Arterial Pressure <NUMBER>
 *
 * Example:
 * [player] call ACM_circulation_fnc_getMAP;
 *
 * Public: No
 */

params ["_patient"];

GET_BLOOD_PRESSURE(_patient) params ["_BPDiastolic", "_BPSystolic"]; 

GET_MAP(_BPSystolic,_BPDiastolic);