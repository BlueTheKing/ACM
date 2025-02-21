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

[missionNamespace, "Draw3D", {
    _thisArgs params ["_originObject", "_radiusX", "_radiusY"];
    
    if (isNull _originObject) exitWith {
        removeMissionEventHandler [_thisType, _thisID];
    };

    private _position = ASLToAGL getPosASLVisual _originObject;

    for "_i" from 1 to 360 do {
        private _divisor = floor(linearConversion [1, 30, (_radiusX max _radiusY), 40, 10, true]);
        if (_i % _divisor == 0) then {
            drawIcon3D ["a3\ui_f\data\map\markers\military\dot_ca.paa", [1,0,0,1], _position vectorAdd [(_radiusX * cos _i), (_radiusY * sin _i), 0], 1.3, 1.3, 0];
        };
    };
}, [_originObject, _radiusX, _radiusY]] call CBA_fnc_addBISEventHandler;