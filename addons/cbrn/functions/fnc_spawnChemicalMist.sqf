#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle spawning mist particles for chemical hazard area. (LOCAL)
 *
 * Arguments:
 * 0: Origin Object <OBJECT>
 * 1: Mist Dimensions <ARRAY[NUMBER,NUMBER,NUMBER,BOOL,NUMBER]>
 * 2: Hazard Type <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_CBRN_fnc_spawnChemicalMist;
 *
 * Public: No
 */

params ["_object", "_radiusDimensions", "_hazardType"];
_radiusDimensions params ["_radiusX", "_radiusY"];

if !(hasInterface) exitWith {};

private _width = _radiusX max _radiusY;

private _mistObject = "#particlesource" createVehicle getPosATL _object;

private _colorArray = switch (_hazardType) do {
    case "chemical_chlorine": {[[0.6,0.63,0,0],[0.6,0.63,0,0.5],[0.6,0.63,0,0]]};
    case "chemical_sarin": {[[0.5,0.5,0.5,0],[0.5,0.5,0.5,0.5],[0.5,0.5,0.5,0]]};
    case "chemical_lewisite": {[[1,1,1,0],[1,1,1,0.9],[1,1,1,0]]};
    default {[[0.8,0.8,0.8,0],[0.8,0.8,0.8,0.2],[0.8,0.8,0.8,0]]};
};

_mistObject setParticleParams [
    ["\A3\Data_f\cl_basic.p3d",1,0,1,0],
    "","Billboard",1,(linearConversion [5, 30, _width, 30, 90, true]),
    [0,0,-52],
    [0,0,0],
    15,
    30,7.84,0.005,
    [5,5,5],
    _colorArray,
    [1,1],
    10,5,
    "","",
    _object,
    0,false,
    0,[]
];
_mistObject setParticleRandom [
    0,
    [(_width * 0.55), (_width * 0.55), -2],
    [0,0,0],
    0,0,
    [0,0,0,0],
    0,0,0,0
];
_mistObject setParticleCircle [(_width * 0.6), [0,0,0]];
_mistObject setDropInterval (linearConversion [5, 30, _width, 0.05, 0.005, true]);

[{
    params ["_args", "_idPFH"];
    _args params ["_object", "_mistObject"];

    private _hazardType = _object getVariable [QGVAR(hazardType), ""];

    if (isNull _object || _hazardType == "") exitWith {
        deleteVehicle _mistObject;

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
}, 1, [_object, _mistObject]] call CBA_fnc_addPerFrameHandler;