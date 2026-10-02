#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if medic can connect AED to patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * Can connect AED <BOOL>
 *
 * Example:
 * [player, cursorTarget] call ACM_circulation_fnc_canConnectAED;
 *
 * Public: No
 */

params ["_medic", "_patient"];

private _targetPatient = _medic getVariable [QGVAR(AED_Target_Patient), objNull];

((([_medic, 'ACM_AED'] call EFUNC(core,itemCount)) > 0) || [_patient] call FUNC(hasAED)) && ((isNull _targetPatient) || (_targetPatient isEqualTo _patient));