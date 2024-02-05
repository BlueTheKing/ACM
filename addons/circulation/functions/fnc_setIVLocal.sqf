#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set IV placement on patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 1] call AMS_circulation_fnc_setIVLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type"];

private _IVState = GET_IV(_patient);

private _partIndex = ALL_BODY_PARTS find _bodyPart;

_IVState set [_partIndex, _type];

_patient setVariable [QGVAR(IV_Placement), _IVState, true];