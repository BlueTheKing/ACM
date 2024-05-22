#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set Pressure Cuff placement on patient (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", false] call ACM_circulation_fnc_setPressureCuffLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_state"];

private _pressureCuffState = GET_PRESSURECUFF(_patient);
private _partIndex = ALL_BODY_PARTS find _bodyPart;

_pressureCuffState set [(_partIndex - 2), _state];

_patient setVariable [QGVAR(PressureCuff_Placement), _pressureCuffState, true];

if !(_state) then {
    [_medic, "ACM_PressureCuff"] call ACEFUNC(common,addToInventory);
};