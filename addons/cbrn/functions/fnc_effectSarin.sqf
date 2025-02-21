#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Sarin effects. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Buildup <NUMBER>
 * 2: Is Exposed? <BOOL>
 * 3: Active PPE <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 1, true, [false,false,false,0]] call ACM_CBRN_fnc_effectSarin;
 *
 * Public: No
 */

params ["_patient", "_buildup", "_isExposed", "_activePPE"];
_activePPE params ["_filtered", "_protectedBody", "_protectedEyes", "_filterLevel"];

if (_buildup < 0.1) exitWith {};

if (_isExposed && GET_PAIN(_patient) < 0.4) then {
    [_patient, 0.5] call ACEFUNC(medical,adjustPainLevel);
};

_patient setVariable [QGVAR(Nausea_Severity), _buildup, true];

if (_buildup < 10) exitWith {};

if ((_patient getVariable [QGVAR(Chemical_Sarin_NextShake), -1]) < CBA_missionTime) then {
    private _nextShakeTime = (linearConversion [10, 60, _buildup, 10, 2, true]) + random (linearConversion [10, 60, _buildup, 10, 5, true]);
    _patient setVariable [QGVAR(Chemical_Sarin_NextShake), (CBA_missionTime + _nextShakeTime)];
    private _severity = 10 min ((linearConversion [10, 60, _buildup, 0.05, 10, true]) + random (linearConversion [10, 60, _buildup, 0.05, 5, true]));
    addCamShake [0.5 * _severity, 5 min (3 * _severity), 1.5 * _severity];
};

if (_buildup < 60) exitWith {};

if !(IS_UNCONSCIOUS(_patient)) then {
    [QACEGVAR(medical,CriticalVitals), _patient] call CBA_fnc_localEvent;
};

if (_buildup >= 100) then {
    [_patient, "Sarin Overexposure"] call ACEFUNC(medical_status,setDead);
};