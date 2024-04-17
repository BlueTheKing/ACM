#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update active types of fluid bags
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_updateActiveFluidBags;
 *
 * Public: No
 */

params ["_patient"];

private _fluidBags = _patient getVariable [QACEGVAR(medical,ivBags), []];

private _activeBagList = [[],[],[],[],[],[]];

{
    _x params ["_partIndex", "_type"];

    private _activeTypesBodyPart = _activeBagList select _partIndex;

    if ((GET_TOURNIQUETS(_patient) select _partIndex == 0) && {!(_type in _activeTypesBodyPart)}) then {
        _activeTypesBodyPart pushBack _type;
    };
} forEach _fluidBags;

private _bagsBodyPart = [];

{
    _bagsBodyPart pushBack ((count _x) max 1);
} forEach _activeBagList;

_patient setVariable [QGVAR(ActiveFluidBags), _bagsBodyPart, true];