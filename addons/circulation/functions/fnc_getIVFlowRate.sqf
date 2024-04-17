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
 * [player, 2] call ACM_circulation_fnc_getIVFlowRate;
 *
 * Public: No
 */

params ["_patient", "_partIndex"];

private _type = GET_IV(_patient) select _partIndex;

switch (_type) do { // TODO pressure bag
    case ACM_IV_14G_M: {IV_CHANGE_PER_SECOND * 1.5};
    case ACM_IO_FAST1_M: {IV_CHANGE_PER_SECOND * 0.65};
    default {IV_CHANGE_PER_SECOND};
};