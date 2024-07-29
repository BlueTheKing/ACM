#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set pulse oximeter placement on patient hand
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
 * [player, cursorTarget, "leftarm", true] call ACM_breathing_fnc_setPulseOximeter;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", ["_state", true]];

private _partIndex = ALL_BODY_PARTS find _bodyPart;

if (_state && HAS_PULSEOX(_patient,(_partIndex - 2))) exitWith {
    [(format [LLSTRING(PulseOximeter_Already), toLower ([_bodyPart] call EFUNC(core,getBodyPartString))]), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

if !(_state) then {
    [_medic, "ACM_PulseOximeter"] call ACEFUNC(common,addToInventory);
};

[_patient, "activity", ([LSTRING(PulseOximeter_ActionLog_Removed), LSTRING(PulseOximeter_ActionLog_Placed)] select _state), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(setPulseOximeterLocal), [_medic, _patient, _bodyPart, _state], _patient] call CBA_fnc_targetEvent;