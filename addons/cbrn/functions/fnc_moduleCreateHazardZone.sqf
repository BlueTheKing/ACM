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
 * [LOGIC] call ACM_CBRN_fnc_moduleCreateHazardZone;
 *
 * Public: No
 */

params ["_logic"];

if !(local _logic) exitWith {};

private _mouseOver = GETMVAR(bis_fnc_curatorObjectPlaced_mouseOver,[""]);

private _radiusX = 5;
private _radiusY = 5;
private _hazardType = "chemical_cs";

private _originObject = [QGVAR(initHazardZone), [_logic, false, _hazardType, [_radiusX,_radiusY,0,false,-1], -1, false, true, ACE_player]] call CBA_fnc_serverEvent;

deleteVehicle _logic;