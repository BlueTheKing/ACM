#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check Capillary Refill Time of patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm"] call ACM_circulation_fnc_checkCapillaryRefill;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

[QGVAR(checkCapillaryRefillLocal), [_medic, _patient, _bodyPart], _patient] call CBA_fnc_targetEvent;