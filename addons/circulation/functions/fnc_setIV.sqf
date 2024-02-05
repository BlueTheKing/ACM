#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set IV placement on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Type <NUMBER>
 * 4: State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 1, true] call AMS_circulation_fnc_setIV;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type", "_state"];

private _hintState = "inserted";
private _hintType = "16g IV";

switch (_type) do {
    case 2: {_hintType = "14g IV";};
    case 3: {_hintType = "IO";};
    default {};
};

private _setState = _type;

if !(_state) then {
    _hintState = "removed";
    _setState = 0;
};

[_patient, "activity", "%1 %2 %3", [[_medic, false, true] call ACEFUNC(common,getName), _hintState, _hintType]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(setIVLocal), [_medic, _patient, _bodyPart, _setState], _patient] call CBA_fnc_targetEvent;