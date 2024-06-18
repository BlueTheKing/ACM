#include "..\script_component.hpp"
/*
 * Author: Blue
 * Generate blood type for unit.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Blood Type <NUMBER>
 *
 * Example:
 * [player] call ACM_circulation_fnc_generateBloodType;
 *
 * Public: No
 */

params ["_patient"];

if (GET_BLOODTYPE(_patient) != -1) exitWith {GET_BLOODTYPE(_patient)};

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

private _bloodTypeRatios = missionNamespace getVariable [QGVAR(BloodTypeList), []];
private _targetBloodType = ACM_BLOODTYPE_O;
private _id = 0;

if !(isPlayer _patient) then {
    _id = floor (random 99);
} else {
    if (isMultiplayer) then {
        private _selectRange = 15;
        _id = parseNumber ((getPlayerUID _patient) select [_selectRange, 2]);
    } else {
        _id = floor (random 99);
    };
};

{
    if (_id in _x) exitWith {
        _targetBloodType = _forEachIndex;
    };
} forEach _bloodTypeRatios;

_patient setVariable [QGVAR(BloodType), _targetBloodType, true];
_targetBloodType;