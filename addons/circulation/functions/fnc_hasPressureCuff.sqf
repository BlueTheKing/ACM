#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if body part has standalone pressure cuff attached
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 *
 * Return Value:
 * Has Pressure Cuff <BOOL>
 *
 * Example:
 * [cursorTarget, "leftarm"] call ACM_circulation_fnc_hasPressureCuff;
 *
 * Public: No
 */

params ["_patient", "_bodyPart"];

private _partIndex = GET_BODYPART_INDEX(_bodyPart);

HAS_PRESSURECUFF(_patient,(_partIndex - 2));