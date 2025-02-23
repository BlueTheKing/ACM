#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle CS effects. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Buildup <NUMBER>
 * 2: Is Exposed? <BOOL>
 * 3: Is Exposed Externally? <BOOL>
 * 4: Active PPE <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 1, true, true, [false,false,false,0]] call ACM_CBRN_fnc_effectCS;
 *
 * Public: No
 */

params ["_patient", "_buildup", "_isExposed", "_isExposedExternal", "_activePPE"];
_activePPE params ["_filtered", "_protectedBody", "_protectedEyes", "_filterLevel"];

if !(_isExposed) exitWith {};

if (_buildup < 0.1) exitWith {};

if (!_filtered && GET_PAIN(_patient) < 0.9) then {
    [_patient, 1] call ACEFUNC(medical,adjustPainLevel);
};

if (_buildup < 50) exitWith {};

if (!_protectedEyes && GVAR(Chemical_CS_Blindness)) then {
    [_patient, true] call FUNC(setBlind);
};