#include "..\script_component.hpp"
/*
 * Author: Blue
 * Show hazard zone radius to unit. (LOCAL)
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Origin Object <OBJECT>
 * 2: Radius Dimensions <ARRAY[NUMBER,NUMBER,NUMBER,BOOL,NUMBER]>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 1, true, [false,false,false,0]] call ACM_CBRN_fnc_showRadius;
 *
 * Public: No
 */

params ["_unit", "_originObject", "_radiusDimensions"];
_radiusDimensions params ["_radiusX", "_radiusY"];

private _helperObject = "ACM_HazardHelperObject" createVehicle (position _originObject);

(getPos _originObject) params ["_originObjectPosX", "_originObjectPosY", "_originObjectPosZ"];

_helperObject setPos [_originObjectPosX, _originObjectPosY, _originObjectPosZ];
_originObject setVariable [QGVAR(referenceObject), _helperObject];

private _blobArray = [];

for "_i" from 1 to 360 do {
    private _biggerRadius = _radiusX max _radiusY;
    if (_i % (_biggerRadius * 4) == 0) then {
        private _blob = "Sign_Sphere25cm_F" createVehicle position _helperObject;
        _blob enableSimulation false;
        _blob attachTo [_helperObject, [(_radiusX * cos _i), (_radiusY * sin _i), 50]];
        _blob setObjectTextureGlobal [0, "#(rgb,8,8,3)color(1,0,0,1)"];
        _blobArray pushBack _blob;
    };
};

_helperObject setVariable [QGVAR(visualArray), _blobArray];

private _thisCurator = getAssignedCuratorLogic _unit;

private _hideArray = _blobArray;
_hideArray pushBack _helperObject;

[{
    params ["_thisCurator", "_originObject", "_hideArray"];

    _thisCurator addCuratorEditableObjects [[_originObject], false]; // Make placed zone visible in zeus
    _thisCurator removeCuratorEditableObjects [_hideArray, false]; 
}, [_thisCurator, _originObject, _hideArray], 0.1] call CBA_fnc_waitAndExecute;

[{
    params ["_args", "_idPFH"];
    _args params ["_originObject", "_helperObject"];

    private _hazardType = _originObject getVariable [QGVAR(hazardType), ""];
    
    if (isNull _originObject || _hazardType == "") exitWith {
        if !(isNull _helperObject) then {
            private _visualArray = _helperObject getVariable [QGVAR(visualArray), []];
            if (count _visualArray > 0) then {
                deleteVehicle _visualArray;
            };
            deleteVehicle _helperObject;
        };

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    (getPos _originObject) params ["_originObjectPosX", "_originObjectPosY", "_originObjectPosZ"];

    _helperObject setPos [_originObjectPosX, _originObjectPosY, (_originObjectPosZ - 50)];
}, 1, [_originObject, _helperObject]] call CBA_fnc_addPerFrameHandler;