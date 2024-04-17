#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if recipient and donor blood type are compatible
 *
 * Arguments:
 * 0: Recipient Blood Type <NUMBER>
 * 1: Donor Blood Type <NUMBER>
 *
 * Return Value:
 * Is compatible <BOOL>
 *
 * Example:
 * [ACM_BLOODTYPE_O, ACM_BLOODTYPE_ABN] call ACM_circulation_fnc_isBloodTypeCompatible;
 *
 * Public: No
 */

params ["_recipientType", "_donorType"];

/*
    0 O+  <= O+, O-
    1 O-  <= O-
    2 A+  <= A+, A-, O+, O-
    3 A-  <= A-, O-
    4 B+  <= B+, B-, O+, O-
    5 B-  <= B-, O-
    6 AB+ <= Any
    7 AB- <= AB-, A-, B-, O-
*/

if (_recipientType == 6) exitWith {true};

_donorType in (BLOODTYPE_COMPATIBLE_LIST select _recipientType);