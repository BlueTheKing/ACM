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
 * ["ON", 0] call ACM_circulation_fnc_convertBloodType;
 *
 * Public: No
 */

params ["_bloodType", ["_returnType", 0]];

/*
    O+  = O   = 0 = ACM_BLOODTYPE_O
    O-  = ON  = 1 = ACM_BLOODTYPE_ON
    A+  = A   = 2 = ACM_BLOODTYPE_A
    A-  = AN  = 3 = ACM_BLOODTYPE_AN
    B+  = B   = 4 = ACM_BLOODTYPE_B
    B-  = BN  = 5 = ACM_BLOODTYPE_BN
    AB+ = AB  = 6 = ACM_BLOODTYPE_AB
    AB- = ABN = 7 = ACM_BLOODTYPE_ABN
*/

private _foundBloodTypeID = 0;

{
    if (_bloodType in _x) exitWith {
        _foundBloodTypeID = _forEachIndex;
    };
} forEach [["O+","O",ACM_BLOODTYPE_O],
["O-","ON",ACM_BLOODTYPE_ON],
["A+","A",ACM_BLOODTYPE_A],
["A-","AN",ACM_BLOODTYPE_AN],
["B+","B",ACM_BLOODTYPE_B],
["B-","BN",ACM_BLOODTYPE_BN],
["AB+","AB",ACM_BLOODTYPE_AB],
["AB-","ABN",ACM_BLOODTYPE_ABN]];

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