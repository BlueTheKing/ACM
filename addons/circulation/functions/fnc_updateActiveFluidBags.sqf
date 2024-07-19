#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update active types of fluid bags on body part
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "leftarm", 0] call ACM_circulation_fnc_updateActiveFluidBags;
 *
 * Public: No
 */

params ["_patient", "_bodyPart"];

if (_bodyPart == "") exitWith {
    _patient setVariable [QGVAR(ActiveFluidBags_IV), ACM_IV_PLACEMENT_DEFAULT_1, true];
    _patient setVariable [QGVAR(ActiveFluidBags_IO), ACM_IO_PLACEMENT_DEFAULT_1, true];
};

private _partIndex = ALL_BODY_PARTS find _bodyPart;

private _fluidBagsBodyPart = (_patient getVariable [QGVAR(IV_Bags), createHashMap]) getOrDefault [_bodyPart, []];

private _activeFluidBagsIV = _patient getVariable [QGVAR(ActiveFluidBags_IV), ACM_IV_PLACEMENT_DEFAULT_1];
private _activeFluidBagsIO = _patient getVariable [QGVAR(ActiveFluidBags_IO), ACM_IO_PLACEMENT_DEFAULT_1];

if ((count _fluidBagsBodyPart) < 2 || (GET_TOURNIQUETS(_patient) select (_partIndex) > 0)) exitWith {
    _activeFluidBagsIV set [_partIndex, [1,1,1]];
    _activeFluidBagsIO set [_partIndex, 1];
    _patient setVariable [QGVAR(ActiveFluidBags_IV), _activeFluidBagsIV, true];
    _patient setVariable [QGVAR(ActiveFluidBags_IO), _activeFluidBagsIO, true];
};

private _activeBagListIV = [[],[],[]];
private _activeBagListIO = [];

{
    _x params ["_type", "", "_accessType", "_accessSite", "_iv"];

    if (_iv) then {
        private _activeBagListIVAccess = _activeBagListIV select _accessSite;
        if (!(_type in _activeBagListIVAccess)) then {
            _activeBagListIVAccess pushBack _type;
        };
    } else {
        if !(_type in _activeBagListIO) then {
            _activeBagListIO pushBack _type;
        };
    };
} forEach _fluidBagsBodyPart;

_activeBagListIV params ["_IVUpper", "_IVMiddle", "_IVLower"];

_activeFluidBagsIV set [_partIndex, ([(count _IVUpper),(count _IVMiddle),(count _IVLower)])];
_activeFluidBagsIO set [_partIndex, (count _activeBagListIO)];

_patient setVariable [QGVAR(ActiveFluidBags_IV), _activeFluidBagsIV, true];
_patient setVariable [QGVAR(ActiveFluidBags_IO), _activeFluidBagsIO, true];