#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to create hazard zone.
 *
 * Arguments:
 * 0: Module Logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [LOGIC] call ace_CBRN_fnc_moduleCreateHazardZone;
 *
 * Public: No
 */

params ["_logic"];

if !(local _logic) exitWith {};

private _mouseOver = GETMVAR(bis_fnc_curatorObjectPlaced_mouseOver,[""]);

private _radiusX = 5;
private _radiusY = 5;
private _hazardType = "chemical_cs";

private _originObject = [_logic, false, _hazardType, [_radiusX,_radiusY,0,false,-1], false, true] call FUNC(initHazardZone);

private _blobArray = [];

for "_i" from 1 to 360 do {
    private _biggerRadius = _radiusX max _radiusY;
    if (_i % (_biggerRadius * 4) == 0) then {
        private _blob = "Sign_Sphere25cm_F" createVehicle position _originObject;
        _blob enableSimulation false;

        _blob attachTo [_originObject, [0,0,0]];
        _blob attachTo [_originObject, [(_radiusX * cos _i), (_radiusY * sin _i), 0]];
        _blob setObjectTextureGlobal [0, "#(rgb,8,8,3)color(1,0,0,1)"];
        _blobArray pushBack _blob;
    };
};

private _helperObject = _originObject getVariable [QGVAR(referenceObject), objNull];

if !(isNull _helperObject) then {
    _helperObject setVariable [QGVAR(visualArray), _blobArray, true];

    private _hideArray = _blobArray;
    _hideArray pushBack _helperObject;

    [{
        params ["_originObject", "_hideArray"];

        {_x addCuratorEditableObjects [[_originObject], false];} forEach allCurators; // Make placed zone visible in zeus
        {_x removeCuratorEditableObjects [_hideArray, false];} forEach allCurators; 
    }, [_originObject, _hideArray], 0.1] call CBA_fnc_waitAndExecute;
};

deleteVehicle _logic;
