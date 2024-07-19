#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get IV/IO flow rate on selected body part
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part Index <NUMBER>
 * 2: Is IV? <BOOL>
 * 3: Access Site <NUMBER>
 *
 * Return Value:
 * Flow rate <NUMBER>
 *
 * Example:
 * [player, 2, true, 0] call ACM_circulation_fnc_getIVFlowRate;
 *
 * Public: No
 */

params ["_patient", "_partIndex", "_iv", "_accessSite"];

private _type = [(GET_IO(_patient) select _partIndex), ((GET_IV(_patient) select _partIndex) select _accessSite)] select _iv;

switch (_type) do { // TODO pressure bag
    case ACM_IV_14G_M: {IV_CHANGE_PER_SECOND * 1.5};
    case ACM_IO_FAST1_M: {IV_CHANGE_PER_SECOND * 0.65};
    case ACM_IO_EZ_M: {IV_CHANGE_PER_SECOND * 0.55};
    default {IV_CHANGE_PER_SECOND};
};