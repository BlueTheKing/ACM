#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get formatted fluid bag name from config string
 *
 * Arguments:
 * 0: Classname <STRING>
 *
 * Return Value:
 * Fluid Bag Name <STRING>
 *
 * Example:
 * ["salineIV_500"] call ACM_circulation_fnc_getFluidBagString;
 *
 * Public: No
 */

params ["_classname"];

private _config = configFile >> QUOTE(ACE_ADDON(medical_treatment)) >> "IV";
private _fluidType = GET_STRING(_config >> _classname >> "type","Blood");
private _fluidAmount = GET_NUMBER(_config >> _classname >>"volume",1000);

if (_fluidType == "Blood") then {
    _fluidType = format ["Blood %1", [GET_NUMBER(_config >> _classname >> "bloodtype",0), 1] call EFUNC(circulation,convertBloodType)];
};

(format ["%1 %2ml", _fluidType, _fluidAmount]);