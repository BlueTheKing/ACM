#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get formatted hours and minutes.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * HH:MM <STRING>
 *
 * Example:
 * [] call ACM_core_fnc_getTimeString;
 *
 * Public: No
 */

date params ["", "", "", "_hour", "_minute"];

format ["%1:%2", _hour, [_minute, 2] call CBA_fnc_formatNumber];