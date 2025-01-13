#include "..\script_component.hpp"
/*
 * Author: Blue
 * Create and set custom blood type list.
 *
 * Arguments:
 * 0: Steam ID and Blood Type array <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [["76561197960287930",1]] call ACM_mission_fnc_createCustomBloodTypeList;
 *
 * Public: No
 */

params ["_array"];

// Blood Type = Blood Type Number
//
// O+  = 0
// O-  = 1
// A+  = 2
// A-  = 3
// B+  = 4
// B-  = 5
// AB+ = 6
// AB- = 7
//
//  ["<SteamID>",<Blood Type Number>]
//  ["76561197960287930",1] // Player's SteamID is set to carry O- blood type

missionNamespace setVariable [QEGVAR(circulation,BloodTypeList_Custom), (createHashMapFromArray _array)];