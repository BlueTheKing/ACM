#include "..\script_component.hpp"
/*
 * Author: Blue
 * Perform fracture realignment on patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftleg"] call ACM_disability_fnc_performFractureRealignment;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

[_patient, "activity", LLSTRING(FractureRealignment_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

if (ACE_player == _medic) then {
    addCamShake [5, 0.4, 10];
};

[QGVAR(performFractureRealignmentLocal), [_medic, _patient, _bodyPart], _patient] call CBA_fnc_targetEvent;