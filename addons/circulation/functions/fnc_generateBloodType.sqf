#include "..\script_component.hpp"
/*
 * Author: Blue
 * Generate blood type for unit
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 2] call AMS_circulation_fnc_generateBloodType;
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

if !(isPlayer _patient) exitWith {
    private _random = random 100;

    private _targetBloodType = AMS_BLOODTYPE_O;

    {
        if (_random in _y) exitWith {
            _targetBloodType = _x;
        };
    } forEach _bloodTypeRatios;

    _patient setVariable [QGVAR(BloodType), _targetBloodType, true];
};

if (_patient getVariable [QGVAR(BloodType), -1] == -1) then {
    // 765611981351544| 3 [ 0 ]|
    private _selectRange = 16;
    private _playerID = getPlayerUID _patient;
    private _id = parseNumber (_playerID select (_selectRange - 1) + (_playerID select _selectRange));

    private _bloodTypeRatios = missionNamespace getVariable [QGVAR(BloodTypeList), []];

    private _targetBloodType = AMS_BLOODTYPE_O;

    {
        if (_id in _x) exitWith {
            _targetBloodType = _forEachIndex;
        };
    } forEach _bloodTypeRatios;

    _patient setVariable [QGVAR(BloodType), _targetBloodType, true];
};