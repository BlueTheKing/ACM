#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Lewisite effects. (LOCAL)
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
 * [player, 1, true, true, [false,false,false,0]] call ACM_CBRN_fnc_effectLewisite;
 *
 * Public: No
 */

params ["_patient", "_buildup", "_isExposed", "_isExposedExternal", "_activePPE"];
_activePPE params ["_filtered", "_protectedBody", "_protectedEyes", "_filterLevel"];

if (_buildup < 0.1) exitWith {};

if (_isExposed || _isExposedExternal) then {
    switch (true) do {
        case (_isExposed && (GET_PAIN(_patient) < 0.4)): {[_patient, 0.5] call ACEFUNC(medical,adjustPainLevel);};
        case (_isExposedExternal && (GET_PAIN(_patient) < 0.1)): {[_patient, 0.2] call ACEFUNC(medical,adjustPainLevel);};
    };
};

if (_buildup < 5) exitWith {};

if (_isExposed || _isExposedExternal) then {
    private _bodyPart = [(ALL_BODY_PARTS selectRandomWeighted [0.7,0.5,0.75,0.75,0.3,0.3]), "head"] select _protectedBody;

    [QACEGVAR(medical,woundReceived), [_patient, [[0.01, _bodyPart, 0.01]], objNull, "lewisiteburn"]] call CBA_fnc_localEvent;
};

if (_buildup < 40) exitWith {};

if (_isExposed) then {
    if (!_filtered) then {
        private _airwayInflammation = GET_AIRWAY_INFLAMMATION(_patient); 

        _patient setVariable [QGVAR(AirwayInflammation), (_airwayInflammation + 1), true];
    };
    
    if (!_protectedEyes && GVAR(lewisiteCauseBlindness)) then {
        [_patient, true] call FUNC(setBlind);
    };
};

if (_buildup < 70) exitWith {};

if (_isExposed && !_protectedEyes && IS_BLINDED(_patient) && GVAR(lewisiteCauseBlindness)) then {
    _patient setVariable [QGVAR(Chemical_Lewisite_Blindness), true, true];
};

private _capillaryDamage = GET_CAPILLARY_DAMAGE(_patient);
private _targetSeverity = linearConversion [70, 90, _buildup, 0, 100, true];

_patient setVariable [QGVAR(CapillaryDamage), ((_capillaryDamage + 1) min _targetSeverity), true];

if (_buildup >= 100) then {
    [_patient, "Lewisite Poisoning"] call ACEFUNC(medical_status,setDead);
};