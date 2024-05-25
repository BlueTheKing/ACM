#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return if position is inside zone
 *
 * Arguments:
 * 0: Zone <ARRAY>
 * 1: Reference Coordinates <ARRAY>
 *
 * Return Value:
 * Is in zone? <BOOL>
 *
 * Example:
 * [[], []] call ACM_GUI_fnc_inZone;
 *
 * Public: No
 */

params ["_zone", "_reference"];
_zone params ["_zoneX", "_zoneY", "_zoneW", "_zoneH"];
_reference params ["_refX", "_refY"];

(_zoneX < _refX) && (_refX < (_zoneX + _zoneW))  && (_zoneY < _refY) && (_refY < (_zoneY + _zoneH));