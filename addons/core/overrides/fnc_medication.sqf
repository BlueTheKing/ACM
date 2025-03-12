#include "..\script_component.hpp"
/*
 * Author: Glowbal, mharis001
 * Administers medication to the patient on the given bodypart.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Treatment <STRING>
 * 4: Item User (not used) <OBJECT>
 * 5: Used Item <STRING>
 * 6: Create Litter <BOOL>
 * 7: Medication Dose <NUMBER>
 * 8: Is IV? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "RightArm", "Morphine", objNull, "ACE_morphine"] call ace_medical_treatment_fnc_medication
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_classname", "", "_usedItem", "", ["_dose", 1], ["_iv", false]];

switch (_usedItem) do {
    case "ACE_morphine": {
        _dose = 10; // Autoinjector has dose of 10mg
    };
    case "ACE_epinephrine": {
        _dose = 0.3; // Autoinjector has dose of 0.3mg
    };
    case "ACM_Autoinjector_ATNA": {
        _classname = "Atropine";
        _dose = 2;
    };
    case "ACM_Autoinjector_Midazolam": {
        _classname = "Midazolam";
    };
    default { };
};

if (_dose < 1 && _classname in ["Atropine_IV", "Atropine"]) then {
    _classname = format ["%1_L", _classname];
};

private _cfg = ["CfgWeapons", "CfgMagazines"] select (isClass (configFile >> "CfgMagazines" >> _usedItem));
private _itemName = getText (configFile >> _cfg >> _usedItem >> "displayName");
[_patient, _itemName] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", ACELSTRING(medical_treatment,Activity_usedItem), [[_medic, false, true] call ACEFUNC(common,getName), _itemName]] call ACEFUNC(medical_treatment,addToLog);

[QACEGVAR(medical_treatment,medicationLocal), [_patient, _bodyPart, _classname, _dose, _iv], _patient] call CBA_fnc_targetEvent;