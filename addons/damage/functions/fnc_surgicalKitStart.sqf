#include "..\script_component.hpp"
/*
 * Author: Brett Mayson
 * Handles the surgical kit treatment start by consuming a suture when applicable
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Use Suture? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, false] call ace_medical_treatment_fnc_surgicalKitStart; // ACM_damage_fnc_surgicalKitStart;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_useSuture", false]];
TRACE_2("surgicalKitStart",_medic,_patient);

if (ACEGVAR(medical_treatment,consumeSurgicalKit) == 2 || _useSuture) then {
    ([_medic, _patient, ["ACE_suture"]] call ACEFUNC(medical_treatment,useItem));
};
