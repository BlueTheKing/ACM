#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle setting lozenge for patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Type <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "Fentanyl"] call ACM_circulation_fnc_setLozenge;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_type", ""]];

if (_type == "") then {
    _patient setVariable [QGVAR(LozengeItem), "", true];
    _patient setVariable [QGVAR(LozengeItem_InsertTime), -1, true];

    if (isNull _medic) then {
        if ((CBA_missionTime - (_patient getVariable [QGVAR(LozengeItem_InsertTime), -1])) > 180) then {
            [LLSTRING(FentanylLozenge_Remove_WoreOff_Hint), 2, _medic] call ACEFUNC(common,displayTextStructured);
        } else {
            [LLSTRING(FentanylLozenge_Remove_HintSelf), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
        };
    } else {
        [LLSTRING(FentanylLozenge_Remove_Complete), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
        [QACEGVAR(common,displayTextStructured), [(format [LLSTRING(FentanylLozenge_Remove_Hint), _medic]), 1.5, _patient], _patient] call CBA_fnc_targetEvent;
    };
} else {
    if ((_patient getVariable [QGVAR(LozengeItem), ""]) != "") exitWith {
        [LLSTRING(FentanylLozenge_Already), 2, _medic] call ACEFUNC(common,displayTextStructured);
    };

    if ((_patient getVariable [QEGVAR(airway,AirwayItem_Oral), ""]) != "") exitWith {
        [LLSTRING(FentanylLozenge_Blocked), 2, _medic] call ACEFUNC(common,displayTextStructured);
    };

    [_patient, LSTRING(FentanylLozenge)] call ACEFUNC(medical_treatment,addToTriageCard);
    
    [_patient, "activity", LLSTRING(FentanylLozenge_Give_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
    [LLSTRING(FentanylLozenge_Give_Complete), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    [QACEGVAR(common,displayTextStructured), [(format [LLSTRING(FentanylLozenge_Give_Hint), _medic]), 2, _patient], _patient] call CBA_fnc_targetEvent;

    _patient setVariable [QGVAR(LozengeItem_InsertTime), CBA_missionTime, true];
    _patient setVariable [QGVAR(LozengeItem), _type, true];

    [QGVAR(administerMedicationLocal), [_patient, BODYPART_INDEX_HEAD, _type, 800, ACM_ROUTE_BUCC], _patient] call CBA_fnc_targetEvent;

    [QGVAR(setLozengeLocal), [_medic, _patient, _type], _patient] call CBA_fnc_targetEvent;
};