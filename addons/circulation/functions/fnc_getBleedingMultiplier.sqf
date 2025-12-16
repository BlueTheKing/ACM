#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get bleeding multiplier.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Minimum Cardiac Output <NUMBER>
 *
 * Return Value:
 * Bleeding Multiplier <NUMBER>
 *
 * Example:
 * [0.127, 0.001, 100] call ACM_circulation_fnc_getBleedingMultiplier;
 *
 * Public: No
 */

params ["_patient", "_minimumCardiacOutput"];

private _cardiacOutput = [_patient] call ACEFUNC(medical_status,getCardiacOutput);
private _resistance = linearConversion [-50, 50, GET_VASOCONSTRICTION(_patient), 1.25, 0.85, true];

(_cardiacOutput max _minimumCardiacOutput) * _resistance * ACEGVAR(medical,bleedingCoefficient)