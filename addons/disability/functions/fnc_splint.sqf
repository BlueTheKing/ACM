#include "..\script_component.hpp"
/*
 * Author: PabstMirror
 * Applies a splint to the patient on the given body part.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Classname <STRING>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [player, cursorObject, "LeftLeg", "ApplySAMSplint"] call ace_medical_treatment_fnc_splint; // ACM_disability_fnc_splint;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_classname"];
TRACE_3("splint",_medic,_patient,_bodyPart);

[QGVAR(splintLocal), [_medic, _patient, _bodyPart, _classname], _patient] call CBA_fnc_targetEvent;

private _item = "ACE_splint";

if (_classname isEqualTo "ApplySAMSplint" && ACEGVAR(medical,fractures) > 1) then {
    _item = "ACM_SAMSplint";
};

[_patient, _item] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", ACELSTRING(medical_treatment,Activity_appliedSplint), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);