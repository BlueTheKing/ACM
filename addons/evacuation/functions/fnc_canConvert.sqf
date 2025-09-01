#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if casualty can be converted.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * Can Be Converted? <BOOL>
 *
 * Example:
 * [player, cursorTarget] call ACM_evacuation_fnc_canConvert;
 *
 * Public: No
 */

params ["_medic", "_patient"];

switch (true) do {
    case !(GVAR(enable));
    case !(isPlayer _patient);
    case (_patient getVariable [QGVAR(casualtyTicketClaimed), false]);
    case !(IS_UNCONSCIOUS(_patient));
    case !(alive _patient);
    case (([1, (GET_SIDE_NUM(side (group _patient)))] call FUNC(getAvailableTickets)) < 1);
    case !([_medic, GVAR(allowConvert)] call ACEFUNC(medical_treatment,isMedic));
    case ([false, !([_medic] call ACEFUNC(medical_treatment,isInMedicalVehicle)), !([_medic] call ACEFUNC(medical_treatment,isInMedicalFacility)),
    (!([_medic] call ACEFUNC(medical_treatment,isInMedicalVehicle)) && !([_medic] call ACEFUNC(medical_treatment,isInMedicalFacility))), false] select GVAR(locationConvert));
    case (IS_BLEEDING(_patient));
    case (GVAR(RequireAntibiotics) && {(([_patient, "Ertapenem_IV", false] call ACEFUNC(medical_status,getMedicationCount)) + ([_patient, "Ertapenem", false] call ACEFUNC(medical_status,getMedicationCount))) < 0.9}): {false};
    default {true};
};