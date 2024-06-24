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
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "RightArm", "Morphine", objNull, "ACE_morphine"] call ace_medical_treatment_fnc_medication
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_classname", "", "_usedItem", "", ["_dose", 1]];

private _cfg = ["CfgWeapons", "CfgMagazines"] select (isClass (configFile >> "CfgMagazines" >> _usedItem));
private _itemName = getText (configFile >> _cfg >> _usedItem >> "displayName");
[_patient, _itemName] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", ACELSTRING(medical_treatment,Activity_usedItem), [[_medic, false, true] call ACEFUNC(common,getName), _itemName]] call ACEFUNC(medical_treatment,addToLog);

[QACEGVAR(medical_treatment,medicationLocal), [_patient, _bodyPart, _classname, _dose], _patient] call CBA_fnc_targetEvent;