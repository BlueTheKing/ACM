#include "..\script_component.hpp"
/*
 * Author: Glowbal, mharis001
 * Administers an IV bag treatment to the patient.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Treatment <STRING>
 * 4: Item User (not used) <OBJECT>
 * 5: Used Item <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "RightArm", "BloodIV", objNull, "ACE_bloodIV"] call ace_medical_treatment_fnc_ivBag
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_classname", "", "_usedItem"];
private _config = configFile >> QUOTE(ACE_ADDON(medical_treatment)) >> "IV";
private _fluidType = GET_STRING(_config >> _classname >> "type","Blood");
private _fluidAmount = GET_NUMBER(_config >> _classname >>"volume",1000);

if (_fluidType == "Blood") then {
    _fluidType = format ["Blood %1", [GET_NUMBER(_config >> _classname >> "bloodtype",0), 1] call EFUNC(circulation,convertBloodType)];
};

private _fluidDesc = format ["%1 %2ml", _fluidType, _fluidAmount];

[_patient, _usedItem] call ACEFUNC(medical_treatment,addToTriageCard);
[_patient, "activity", "%1 began transfusing fluids (%2)", [[_medic, false, true] call ACEFUNC(common,getName), _fluidDesc]] call ACEFUNC(medical_treatment,addToLog);

private _partIndex = ALL_BODY_PARTS find tolowerANSI _bodyPart;

[QACEGVAR(medical_treatment,ivBagLocal), [_patient, _bodyPart, _classname, (GET_IV(_patient) select _partIndex)], _patient] call CBA_fnc_targetEvent;
