#include "..\script_component.hpp"
/*
 * Author: BaerMitUmlaut
 * Plays the corresponding treatment animation.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Treatment name <STRING>
 * 3: Is self treatment <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorObject, joe, "Splint", true] call ace_medical_ai_fnc_playTreatmentAnim
 *
 * Public: No
 */

params ["_medic", "_patient", "_actionName", "_isSelfTreatment"];
TRACE_3("playTreatmentAnim",_medic,_actionName,_isSelfTreatment);

if (!isNull objectParent _medic) exitWith {};

private _config = configFile >> QACEGVAR(medical_treatment,actions) >> _actionName;

private _configProperty = "animationMedic";
if (_isSelfTreatment) then {
    _configProperty = _configProperty + "Self";
};
if (stance _medic == "PRONE") then {
    _configProperty = _configProperty + "Prone";
};

if (IS_UNCONSCIOUS(_patient) && {isNumber (_config >> "ACM_rollToBack")}) then {
    if ((getNumber (_config >> "ACM_rollToBack")) > 0) then {
        [_patient, "AinjPpneMstpSnonWrflDnon_rolltoback", 2] call ACEFUNC(common,doAnimation);
    };
};

if (_actionName == "CPR") exitWith {
    [_medic, "ACM_CPR"] call ACEFUNC(common,doAnimation);
};

private _anim = getText (_config >> _configProperty);
if (_anim == "") exitWith {
    _medic call ACEFUNC(common,goKneeling);
    WARNING_2("no anim [%1, %2]",_actionName,_configProperty); 
};

private _wpn = switch (true) do {
    case ((currentWeapon _medic) == ""): {"non"};
    case ((currentWeapon _medic) == (primaryWeapon _medic)): {"rfl"};
    case ((currentWeapon _medic) == (handgunWeapon _medic)): {"pst"};
    default {"non"};
};
_anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;

[_medic, _anim] call ACEFUNC(common,doAnimation);
