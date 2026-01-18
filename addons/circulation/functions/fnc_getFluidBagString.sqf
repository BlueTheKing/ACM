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

private _classnameSplit = _classname splitString "_";
private _freshBloodID = -1;

if ((_classnameSplit select 0) == "FreshBloodBag") then {
    _freshBloodID = parseNumber (_classnameSplit select 2);
    _classname = format ["%1_%2", (_classnameSplit select 0), (_classnameSplit select 1)];
};

private _config = configFile >> QUOTE(ACE_ADDON(medical_treatment)) >> "IV";
private _fluidType = GET_STRING(_config >> _classname >> "type","Blood");
private _fluidAmount = GET_NUMBER(_config >> _classname >>"volume",1000);

private _returnArray = [];

switch (_fluidType) do {
    case "Blood": {
        _returnArray = ["%1 %2 %3ml", LSTRING(Blood), ([GET_NUMBER(_config >> _classname >> "bloodtype",0), 1] call FUNC(convertBloodType)), _fluidAmount];
    };
    case "FreshBlood": {
        _returnArray = ["%1 %2ml [ID:%3]", LSTRING(FreshBlood), _fluidAmount, _freshBloodID];
    };
    default {
        _returnArray = ["%1 %2ml", _fluidType, _fluidAmount];
    };
};

_returnArray;