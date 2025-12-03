#include "..\script_component.hpp"
/*
 * Author: Blue
 * Administer medication from item.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Treatment Classname <STRING>
 * 4: Used Item <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "rightarm", "Morphine", "ACE_morphine"] call ACM_circulation_fnc_administerMedicationItem;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_treatmentClassname", "_usedItem"];

private _medication = "";
private _route = -1;
private _dose = 0;

switch (_usedItem) do {
    case "ACM_Paracetamol": {
        _medication = "Paracetamol";
        _dose = 500; // mg
        _route = ACM_ROUTE_PO;
    };
    case "ACM_Inhaler_Penthrox": {
        _medication = "Methoxyflurane";
        _dose = 1; // mg
        _route = ACM_ROUTE_INHALE;
    };
    case "ACM_AmmoniaInhalant": {
        _medication = "AmmoniaInhalant";
        _dose = 45; // mg
        _route = ACM_ROUTE_INHALE;
    };
    case "ACM_Spray_Naloxone": {
        _medication = "Naloxone";
        _dose = 4; // mg
        _route = ACM_ROUTE_INHALE;
    };
    case "ACE_morphine": {
        _medication = "Morphine";
        _dose = 5; // mg
        _route = ACM_ROUTE_IM;
    };
    case "ACE_epinephrine": {
        _medication = "Epinephrine";
        _dose = 0.3; // mg
        _route = ACM_ROUTE_IM;
    };
    case "ACM_Autoinjector_ATNA": {
        _medication = "Atropine";
        _dose = 2; // mg
        _route = ACM_ROUTE_IM;
    };
    case "ACM_Autoinjector_Midazolam": {
        _medication = "Midazolam";
        _dose = 10; // mg
        _route = ACM_ROUTE_IM;
    };
    default {};
};

if (_medication == "" || _route == -1 || _dose == 0) exitWith {};

private _cfg = ["CfgWeapons", "CfgMagazines"] select (isClass (configFile >> "CfgMagazines" >> _usedItem));
private _itemName = getText (configFile >> _cfg >> _usedItem >> "displayName");
[_patient, _itemName] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", ACELSTRING(medical_treatment,Activity_usedItem), [[_medic, false, true] call ACEFUNC(common,getName), _itemName]] call ACEFUNC(medical_treatment,addToLog);

[QGVAR(administerMedicationLocal), [_patient, _partIndex, _medication, _dose, _route], _patient] call CBA_fnc_targetEvent;