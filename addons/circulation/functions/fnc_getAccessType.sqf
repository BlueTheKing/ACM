#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get access type on body part and access site
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Is IV? <BOOL>
 * 2: Body Part Part Index <NUMBER>
 * 3: Access Site <NUMBER>
 *
 * Return Value:
 * Access Type <NUMBER>
 *
 * Example:
 * [cursorTarget, true, 3, 0] call ACM_circulation_fnc_getAccessType;
 *
 * Public: No
 */

params ["_patient", "_iv", "_partIndex", ["_accessSite", -1]];

[(GET_IO(_patient) select _partIndex), ((GET_IV(_patient) select _partIndex) select _accessSite)] select _iv;