#include "..\script_component.hpp"
/*
 * Author: Blue
 * Module to handle creating hazard zone.
 *
 * Arguments:
 * 0: The module logic <OBJECT>
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
systemchat format ["%1",_mouseOver];

private _radiusX = 5;
private _radiusY = 5;
private _hazardType = "chemical_cs";

private _originObject = [_logic, false, _hazardType, [_radiusX,_radiusY,0,false,-1], false] call FUNC(initHazardZone);

private _blobArray = [];

for "_i" from 1 to 360 do {
	private _biggerRadius = _radiusX max _radiusY;
	if (_i % (_biggerRadius * 4) == 0) then {
    	private _blob = "Sign_Sphere25cm_F" createVehicle position _originObject;

		_blob attachTo [_originObject, [0,0,0]];
		_blob attachTo [_originObject, [(_radiusX * cos _i), (_radiusY * sin _i), 0]];
		_blob setObjectTextureGlobal [0, "#(rgb,8,8,3)color(1,1,1,1)"];
		_blobArray pushBack _blob;
	};
};

private _helperObject = _originObject getVariable [QGVAR(referenceObject), objNull];

//if !(isNull _helperObject) then {};

_helperObject setVariable [QGVAR(visualArray), _blobArray, true];

{_x addCuratorEditableObjects [[_originObject], false];} forEach allCurators; // Make placed zone visible in zeus

deleteVehicle _logic;
