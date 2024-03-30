#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update different types of fluid bags that are active on body parts
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call AMS_circulation_fnc_updateFluidBagTypes;
 *
 * Public: No
 */

params ["_patient"];

private _activeTypesArray = _patient getVariable [QGVAR(FluidBags_ActiveTypes), [0,0,0,0,0,0]];

private _fluidBags = _patient getVariable [QACEGVAR(medical,ivBags), []];
private _tourniquets = GET_TOURNIQUETS(_patient);

private _activeBloodBags = [0,0,0,0,0,0];
private _activePlasmaBags = [0,0,0,0,0,0];
private _activeSalineBags = [0,0,0,0,0,0];

{
    _x params ["", "_type", "_partIndex"];

    if ((_tourniquets select _partIndex) == 0) then {
        switch (_type) do {
            case "Plasma": {
                if ((_activePlasmaBags select _partIndex) == 0) then {
                    _activePlasmaBags set [_partIndex, 1];
                };
            };
            case "Saline": {
                if ((_activeSalineBags select _partIndex) == 0) then {
                    _activeSalineBags set [_partIndex, 1];
                };
            };
            default {
                if ((_activeBloodBags select _partIndex) == 0) then {
                    _activeBloodBags set [_partIndex, 1];
                };
            };
        };
    };
} forEach _fluidBags;

{
    _activeTypesArray set [_forEachIndex, (_x + (_activePlasmaBags select _forEachIndex) + (_activeSalineBags select _forEachIndex))];
} forEach _activeBloodBags;

_patient setVariable [QGVAR(FluidBags_ActiveTypes), _activeTypesArray];