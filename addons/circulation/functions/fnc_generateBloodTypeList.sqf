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
 * [] call ACM_circulation_fnc_generateBloodTypeList;
 *
 * Public: No
 */

params ["_patient"];

/*
    O+ 39% 
    A+ 28%
    B+ 18%
    O- 5%
    AB+ 4%
    A- 3%
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

private _total = -1;
private _ratioArray = [];
{
    private _list = [_total, _x] call _fnc_generateListFromRatio;
    _total = _total + (count _list);
    _ratioArray pushBack _list;
} forEach [(missionNamespace getVariable QGVAR(BloodType_Ratio_O)),
(missionNamespace getVariable QGVAR(BloodType_Ratio_ON)),
(missionNamespace getVariable QGVAR(BloodType_Ratio_A)),
(missionNamespace getVariable QGVAR(BloodType_Ratio_AN)),
(missionNamespace getVariable QGVAR(BloodType_Ratio_B)),
(missionNamespace getVariable QGVAR(BloodType_Ratio_BN)),
(missionNamespace getVariable QGVAR(BloodType_Ratio_AB)),
(missionNamespace getVariable QGVAR(BloodType_Ratio_ABN))];

missionNamespace setVariable [QGVAR(BloodTypeList), _ratioArray];