#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle administering IM injection.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Treatment <STRING>
 * 4: Used Item <STRING>
 * 5: Return Syringe? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "RightArm", "Morphine", "ACE_morphine", true] call ACM_circulation_fnc_Syringe_Inject;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_classname", "_usedItem", ["_returnSyringe", true]];

private _itemName = getText (configFile >> "CfgWeapons" >> _usedItem >> "displayName");
[_patient, format ["%1 (IM)", _itemName]] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", "%1 used %2 (IM)", [[_medic, false, true] call ACEFUNC(common,getName), _itemName]] call ACEFUNC(medical_treatment,addToLog);

if (_returnSyringe) then {
	[_medic, "ACM_Syringe_IM"] call ACEFUNC(common,addToInventory);
};

[QACEGVAR(medical_treatment,medicationLocal), [_patient, _bodyPart, _classname], _patient] call CBA_fnc_targetEvent;