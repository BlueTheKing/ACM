#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle AED button press to begin manual charge
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_AED_Button_ManualCharge;
 *
 * Public: No
 */

params ["_patient"];

if (isNull _patient) exitWith {};

private _medic = _patient getVariable [QGVAR(AED_Provider), objNull];

if (isNull _medic) exitWith {};

if ([_medic, _patient] call FUNC(AED_CanManualCharge)) then {
    [_medic, _patient, true] call FUNC(AED_BeginCharge);
};