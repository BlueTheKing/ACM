#include "..\script_component.hpp"
/*
 * Author: Glowbal, mharis001
 * Local callback for administering an IV bag to a patient.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Treatment <STRING>
 * 3: Access Type <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "RightArm", "BloodIV", 1] call ace_medical_treatment_fnc_ivBagLocal
 *
 * Public: No
 */

params ["_patient", "_bodyPart", "_classname", "_accessType"];

// Exit if patient has max blood volume
private _bloodVolume = GET_BLOOD_VOLUME(_patient);
if (_bloodVolume >= DEFAULT_BLOOD_VOLUME) exitWith {};

private _partIndex = ALL_BODY_PARTS find tolowerANSI _bodyPart;

// Get attributes for the used IV
private _defaultConfig = configFile >> QUOTE(ACE_ADDON(medical_treatment)) >> "IV";
private _ivConfig = _defaultConfig >> _classname;

private _volume = GET_NUMBER(_ivConfig >> "volume",getNumber (_defaultConfig >> "volume"));
private _type = GET_STRING(_ivConfig >> "type",getText (_defaultConfig >> "type"));
private _bloodType = GET_NUMBER(_ivConfig >> "bloodtype",-1);

// Add IV bag to patient's ivBags array
private _ivBags = _patient getVariable [QACEGVAR(medical,ivBags), []];
_ivBags pushBack [_partIndex, _type, _volume, _bloodType, _accessType];
_patient setVariable [QACEGVAR(medical,ivBags), _ivBags, true];

[_patient] call EFUNC(circulation,updateActiveFluidBags);

if (GET_BLOODTYPE(_patient) == -1) then {
	[_patient] call EFUNC(circulation,generateBloodType);
};