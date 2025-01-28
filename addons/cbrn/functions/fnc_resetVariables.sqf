#include "..\script_component.hpp"
/*
 * Author: Blue
 * Reset CBRN variables to default values. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_resetVariables;
 *
 * Public: No
 */

params ["_patient"];

_patient setVariable [QGVAR(Exposed_State), false, true];
_patient setVariable [QGVAR(BreathingAbility_State), 1, true];
_patient setVariable [QGVAR(BreathingAbility_Increase_State), 1, true];

_patient setVariable [QGVAR(EyesWashed), false, true];

_patient setVariable [QGVAR(Filter_State), 1200];

{
    private _category = _x;
    
    {
        private _hazardType = format ["%1_%2", _category, _x];
        _patient setVariable [(format ["ACM_CBRN_%1_Buildup", toLower _hazardType]), 0, true];
        _patient setVariable [(format ["ACM_CBRN_%1_Buildup_Threshold", toLower _hazardType]), -1, true];
        _patient setVariable [(format ["ACM_CBRN_%1_Exposed_State", toLower _hazardType]), false];
        _patient setVariable [(format ["ACM_CBRN_%1_WasExposed", toLower _hazardType]), false, true];
    } forEach _y;
} forEach GVAR(HazardType_List);