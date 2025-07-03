#include "..\script_component.hpp"
/*
 * Author: Blue
 * Return if reference zone overlaps zone.
 *
 * Arguments:
 * 0: Zone <ARRAY>
 * 1: Zone 2 <ARRAY>
 *
 * Return Value:
 * Overlapping zone? <BOOL>
 *
 * Example:
 * [[], []] call ACM_GUI_fnc_isZoneOverlapping;
 *
 * Public: No
 */

params ["_zone", "_refZone"];
_zone params ["_zoneX", "_zoneY", "_zoneW", "_zoneH"];
_refZone params ["_refZoneX", "_refZoneY", "_refZoneW", "_refZoneH"];

_zoneX < _refZoneX + _refZoneW && _refZoneX < _zoneX + _zoneW && _zoneY < _refZoneY + _refZoneH && _refZoneY < _zoneY + _zoneH;