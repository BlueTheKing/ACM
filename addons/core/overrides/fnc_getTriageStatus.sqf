#include "..\script_component.hpp"
/*
 * Author: Glowbal, mharis001
 * Returns the current triage status of the unit.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Triage Info <ARRAY>
 *   0: Status ID <NUMBER>
 *   1: Name <STRING>
 *   2: Color <ARRAY>
 *   3: Text Color <ARRAY>
 *
 * Example:
 * [player] call ace_medical_treatment_fnc_getTriageStatus
 *
 * Public: No
 */

params ["_unit"];

private _status = _unit getVariable [QACEGVAR(medical,triageLevel), -1];

switch (_status) do {
    case 1: {[1, ACELLSTRING(medical_treatment,Triage_Status_Minimal),   [TRIAGE_COLOR_MINIMAL],   [TRIAGE_TEXT_COLOR_MINIMAL]]};
    case 2: {[2, ACELLSTRING(medical_treatment,Triage_Status_Delayed),   [TRIAGE_COLOR_DELAYED],   [TRIAGE_TEXT_COLOR_DELAYED]]};
    case 3: {[3, ACELLSTRING(medical_treatment,Triage_Status_Immediate), [TRIAGE_COLOR_IMMEDIATE], [TRIAGE_TEXT_COLOR_IMMEDIATE]]};
    case 4: {[4, LELSTRING(GUI,Triage_Priority4),  [TRIAGE_COLOR_DECEASED],  [TRIAGE_TEXT_COLOR_DECEASED]]};
    default {[0, ACELLSTRING(medical_treatment,Triage_Status_None),      [TRIAGE_COLOR_NONE],      [TRIAGE_TEXT_COLOR_NONE]]};
};
