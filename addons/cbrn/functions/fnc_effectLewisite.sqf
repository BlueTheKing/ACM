#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Lewisite effects. (LOCAL)
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
 * [player, 1, true, [false,false,false,0]] call ACM_CBRN_fnc_effectLewisite;
 *
 * Public: No
 */

params ["_patient", "_buildup", "_isExposed", "_activePPE"];
_activePPE params ["_filtered", "_protectedBody", "_protectedEyes", "_filterLevel"];

if (_buildup < 0.1) exitWith {};

if (_isExposed && GET_PAIN(_patient) < 0.4) then {
    [_patient, 0.5] call ACEFUNC(medical,adjustPainLevel);
};

if (_buildup < 5) exitWith {};

if (_isExposed) then {
    private _bodyPart = [(ALL_BODY_PARTS selectRandomWeighted [0.7,0.5,0.75,0.75,0.3,0.3]), "head"] select _protectedBody;

    [QACEGVAR(medical,woundReceived), [_patient, [[0.01, _bodyPart, 0.01]], objNull, "lewisiteburn"]] call CBA_fnc_localEvent;

    if (!_protectedEyes && GVAR(Chemical_Lewisite_Blindness)) then {
        [_patient, true] call FUNC(setBlind);
        _patient setVariable [QGVAR(Chemical_Lewisite_Blindness), true, true];
    };
};

if (_buildup < 40) exitWith {};

if (_isExposed && !_filtered) then {
    private _airwayInflammation = _patient getVariable [QGVAR(AirwayInflammation), 0];

    _patient setVariable [QGVAR(AirwayInflammation), (_airwayInflammation + 1), true];
};

if (_buildup < 70) exitWith {};

private _capillaryDamage = _patient getVariable [QGVAR(CapillaryDamage), 0];
private _targetSeverity = linearConversion [70, 90, _buildup, 0.1, 10, true];

_patient setVariable [QGVAR(CapillaryDamage), ((_capillaryDamage + 1) min _targetSeverity), true];

if (_buildup >= 100) then {
    [_patient, "Lewisite Poisoning"] call ACEFUNC(medical_status,setDead);
};