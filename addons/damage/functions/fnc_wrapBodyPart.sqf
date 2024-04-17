#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle wrapping wounds/bandages on body part
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Wrappable Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "head", 1] call ACM_damage_fnc_wrapBodyPart;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type"];

private _output = "bandages";

if (_type isEqualTo 1) then {
    _output = "clotted wounds";
};

[_patient, "activity", "%1 has wrapped %2", [[_medic] call ACEFUNC(common,getName), _output]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(wrapBodyPartLocal), [_medic, _patient, _bodyPart, _type], _patient] call CBA_fnc_targetEvent;