#include "..\script_component.hpp"
/*
 * Author: Blue
 * Convert inputted blood type into desired return type
 *
 * Arguments:
 * 0: Blood Type <STRING/NUMBER>
 * 1: Return Type <NUMBER>
   * 0: As saved in unit variable (ID) <NUMBER>
   * 1: Meant to be read <STRING>
   * 2: As written in configs <STRING>
 *
 * Return Value:
 * Blood Type <STRING/NUMBER>
 *
 * Example:
 * ["ON", 0] call AMS_circulation_fnc_convertBloodType;
 *
 * Public: No
 */

params ["_bloodType", ["_returnType", 0]];

/*
    O+  = O   = 0 = AMS_BLOODTYPE_O
    O-  = ON  = 1 = AMS_BLOODTYPE_ON
    A+  = A   = 2 = AMS_BLOODTYPE_A
    A-  = AN  = 3 = AMS_BLOODTYPE_AN
    B+  = B   = 4 = AMS_BLOODTYPE_B
    B-  = BN  = 5 = AMS_BLOODTYPE_BN
    AB+ = AB  = 6 = AMS_BLOODTYPE_AB
    AB- = ABN = 7 = AMS_BLOODTYPE_ABN
*/

private _foundBloodTypeID = 0;

{
    if (_bloodType in _x) exitWith {
        _foundBloodTypeID = _forEachIndex;
    };
} forEach [["O+","O",AMS_BLOODTYPE_O],
["O-","ON",AMS_BLOODTYPE_ON],
["A+","A",AMS_BLOODTYPE_A],
["A-","AN",AMS_BLOODTYPE_AN],
["B+","B",AMS_BLOODTYPE_B],
["B-","BN",AMS_BLOODTYPE_BN],
["AB+","AB",AMS_BLOODTYPE_AB],
["AB-","ABN",AMS_BLOODTYPE_ABN]];

switch (_returnType) do {
    case 1: {
        (["O+","O-","A+","A-","B+","B-","AB+","AB-"] select _foundBloodTypeID);
    };
    case 2: {
        (["O","ON","A","AN","B","BN","AB","ABN"] select _foundBloodTypeID);
    };
    default {
        _foundBloodTypeID;
    };
};