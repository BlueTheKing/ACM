#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if AED is ready to measure BP
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * Can measure blood pressure <BOOL>
 *
 * Example:
 * [player, cursorTarget] call ACM_circulation_fnc_AED_CanMeasureBP;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

([_patient, _bodyPart, 3] call FUNC(hasAED) || (_bodyPart == "body" && [_patient, "", 3] call FUNC(hasAED))) && !(_patient getVariable [QGVAR(AED_InUse), false]) && !(_patient getVariable [QGVAR(AED_PressureCuffBusy), false]);