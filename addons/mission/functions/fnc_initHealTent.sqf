#include "..\script_component.hpp"
/*
 * Author: Blue
 * Init interactions for heal tent
 *
 * Arguments:
 * 0: Tent Object <OBJECT>
 * 1: Interaction Distance <NUMBER>
 * 2: Interaction Position <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [this] call ACM_mission_fnc_initHealTent;
 *
 * Public: No
 */

params ["_object", ["_distance", 5], ["_position", [0,0,0]]];

[_object, _distance, _position] call FUNC(initFullHealFacility);