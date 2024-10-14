#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Plays the corresponding treatment animation.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Treatment name <STRING>
 * 2: Is self treatment <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorObject, "Splint", true] call ace_medical_ai_fnc_playTreatmentAnim
 *
 * Public: No
 */

params ["_unit", "_actionName", "_isSelfTreatment"];
TRACE_3("playTreatmentAnim",_unit,_actionName,_isSelfTreatment);

if (!isNull objectParent _unit) exitWith {};

private _configProperty = "animationMedic";
if (_isSelfTreatment) then {
    _configProperty = _configProperty + "Self";
};
if (stance _unit == "PRONE") then {
    _configProperty = _configProperty + "Prone";
};

if (_actionName == "CPR") exitWith {
    [_unit, "ACM_CPR"] call ACEFUNC(common,doAnimation);
};

private _anim = getText (configFile >> QACEGVAR(medical_treatment,Actions) >> _actionName >> _configProperty);
if (_anim == "") exitWith {
    _unit call ACEFUNC(common,goKneeling);
    WARNING_2("no anim [%1, %2]",_actionName,_configProperty); 
};

private _wpn = switch (true) do {
    case ((currentWeapon _unit) == ""): {"non"};
    case ((currentWeapon _unit) == (primaryWeapon _unit)): {"rfl"};
    case ((currentWeapon _unit) == (handgunWeapon _unit)): {"pst"};
    default {"non"};
};
_anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;

[_unit, _anim] call ACEFUNC(common,doAnimation);
