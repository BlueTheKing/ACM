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

//_patient setVariable [QGVAR(), 0, true];

{
    private _category = _x;
    
    {
        private _hazardType = format ["%1_%2", _category, _x];
        _patient setVariable [(format ["ACM_CBRN_%1_Buildup", toLower _hazardType]), 0, true];
    } forEach _y;
} forEach GVAR(HazardType_List);