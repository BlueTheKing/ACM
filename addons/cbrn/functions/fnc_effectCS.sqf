#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle CS effects. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Buildup <NUMBER>
 * 2: Is Exposed? <BOOL>
 * 3: Active PPE <ARRAY<BOOL>>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 1, true, []] call ACM_CBRN_fnc_effectCS;
 *
 * Public: No
 */

params ["_patient", "_buildup", "_isExposed", "_activePPE"];
_activePPE params ["_filtered", "_protectedBody", "_protectedEyes", "_filterLevel"];

if (_buildup < 0.1) exitWith {};

//_patient setVariable [QGVAR(Symptom_Cough), true, true];

if (GET_PAIN(_patient) < 0.9) then {
    [_patient, 1] call ACEFUNC(medical,adjustPainLevel);
};

private _currentThreshold = _patient getVariable [QGVAR(Chemical_CS_EffectThreshold), 0];

if (_buildup < 50) exitWith {
    if ([_patient, "CBRN_Chemical_CS"] call ACEFUNC(medical_status,getMedicationCount) > 0) then {
        [_patient, "CBRN_Chemical_CS"] call EFUNC(circulation,removeMedicationAdjustment);
    };
};

if (!_protectedEyes && false && !(_patient getVariable [QGVAR(Chemical_CS_WasBlind), false])) then { // TODO
    [_patient, true] call EFUNC(disability,setBlind);
    _patient setVariable [QGVAR(Chemical_CS_WasBlind), true, true];
};