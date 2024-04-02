#include "..\script_component.hpp"
/*
 * Author: Blue
 * Generate blood type list from ratios set in settings
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AMS_circulation_fnc_generateBloodTypeList;
 *
 * Public: No
 */

params ["_patient"];

/*
    O+ 41% 
    A+ 30%
    B+ 20%
    O- 7%
    AB+ 5%
    A- 4%
    B- 2%
    AB- 1%
*/

private _fnc_generateListFromRatio = {
    params ["_startN", "_length"];

    private _array = [];

    for "_i" from 1 to _length do {
        _array pushBack (_i + _startN);
    };

    _array;
};

private _ratio_O = missionNamespace getVariable QGVAR(BloodType_Ratio_O);
private _ratio_ON = missionNamespace getVariable QGVAR(BloodType_Ratio_ON);
private _ratio_A = missionNamespace getVariable QGVAR(BloodType_Ratio_A);
private _ratio_AN = missionNamespace getVariable QGVAR(BloodType_Ratio_AN);
private _ratio_B = missionNamespace getVariable QGVAR(BloodType_Ratio_B);
private _ratio_BN = missionNamespace getVariable QGVAR(BloodType_Ratio_BN);
private _ratio_AB = missionNamespace getVariable QGVAR(BloodType_Ratio_AB);
private _ratio_ABN = missionNamespace getVariable QGVAR(BloodType_Ratio_ABN);

private _ratioArray = [[AMS_BLOODTYPE_O, _ratio_O],
[AMS_BLOODTYPE_A, _ratio_A],
[AMS_BLOODTYPE_B, _ratio_B],
[AMS_BLOODTYPE_ON, _ratio_ON],
[AMS_BLOODTYPE_AB, _ratio_AB],
[AMS_BLOODTYPE_AN, _ratio_AN],
[AMS_BLOODTYPE_BN, _ratio_BN],
[AMS_BLOODTYPE_ABN, _ratio_ABN]];

private _unsortedArray = [];

{
    _x params ["_intendedIndex", "_ratio"];

    if (_forEachIndex == 0) then {
        _unsortedArray pushBack [_intendedIndex, ([0, _ratio] call _fnc_generateListFromRatio)];
    } else {
        _unsortedArray pushBack [_intendedIndex, ([(_ratioArray select (_forEachIndex-1) + 1), _ratio] call _fnc_generateListFromRatio)];
    };
} forEach _ratioArray;

private _array = [];
private _targetIndex = 0;

{
    _x params ["_index", "_list"];
    
    if (_index == _targetIndex) then {
        _array pushBack _list;
        _targetIndex = _targetIndex + 1;
    };
    
} forEach _unsortedArray;

missionNamespace setVariable [QGVAR(BloodTypeList), _array, true];