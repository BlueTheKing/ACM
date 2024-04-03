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
 * [player] call AMS_circulation_fnc_updateActiveFluidBags;
 *
 * Public: No
 */

params ["_patient"];

private _fluidBags = _patient getVariable [QACEGVAR(medical,ivBags), []];

private _activeTypes = [];

{
    _x params ["_partIndex", "_type"];

    if (GET_TOURNIQUETS(_patient) select _partIndex && {!(_type in _activeTypes)}) then {
        _activeTypes pushBack _type;
    };
    
} forEach _fluidBags;

_patient setVariable [QGVAR(ActiveFluidBags), ((count _activeTypes) max 1), true];