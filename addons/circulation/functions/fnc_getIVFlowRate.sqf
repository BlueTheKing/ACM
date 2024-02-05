#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get IV/IO flow rate on selected body part
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part Index <NUMBER>
 *
 * Return Value:
 * Flow rate <NUMBER>
 *
 * Example:
 * [player, 2] call AMS_circulation_fnc_getIVFlowRate;
 *
 * Public: No
 */

params ["_patient", "_partIndex"];

private _type = GET_IV(_patient) select _partIndex;

switch (_type) do {
    case 2: {IV_CHANGE_PER_SECOND * 1.5};
    case 3: {IV_CHANGE_PER_SECOND * 0.7};
    default {IV_CHANGE_PER_SECOND};
};