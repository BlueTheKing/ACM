#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Chlorine effects. (LOCAL)
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
 * [player, 1, true, true, [false,false,false,0]] call ACM_CBRN_fnc_effectChlorine;
 *
 * Public: No
 */

params ["_patient", "_buildup", "_isExposed", "_isExposedExternal", "_activePPE"];
_activePPE params ["_filtered", "_protectedBody", "_protectedEyes", "_filterLevel"];

if (_buildup < 0.1) exitWith {};

if (_isExposed || _isExposedExternal) then {
    switch (true) do {
        case (_isExposed && (GET_PAIN(_patient) < 0.4)): {[_patient, 0.5] call ACEFUNC(medical,adjustPainLevel);};
        case (_isExposedExternal && (GET_PAIN(_patient) < 0.05)): {[_patient, 0.1] call ACEFUNC(medical,adjustPainLevel);};
    };
};

if (_isExposed || _isExposedExternal) then {
    if !(_filtered) then {
        private _airwayInflammation = _patient getVariable [QGVAR(AirwayInflammation), 0];

        _patient setVariable [QGVAR(AirwayInflammation), (_airwayInflammation + 1), true];
    };

    private _skinIrritationArray = +(_patient getVariable [QGVAR(SkinIrritation), [0,0,0,0,0,0]]);
    private _skinIrritationTarget = round(linearConversion [25, 95, _buildup, 20, 100, true]);

    {
        if (_x < _skinIrritationTarget) then {
            if (_forEachIndex == 0 && _filtered && _protectedEyes) exitWith {};
            if (_forEachIndex > 0 && _protectedBody) exitWith {};

            _skinIrritationArray set [_forEachIndex, ((_x + 1) min _skinIrritationTarget)]
        };
    } forEach _skinIrritationArray;

    _patient setVariable [QGVAR(SkinIrritation), _skinIrritationArray, true];
};

if (_buildup < 25) exitWith {};

if (_isExposed && GET_PAIN(_patient) < 0.9) then {
    [_patient, 1] call ACEFUNC(medical,adjustPainLevel);
};

if (_buildup < 50) exitWith {};

if (_isExposed) then {
    if (!_filtered) then {
        private _damage = _patient getVariable [QGVAR(LungTissueDamage), 0];

        _patient setVariable [QGVAR(LungTissueDamage), (_damage + 1), true];
    };

    if (!_protectedEyes && GVAR(chlorineCauseBlindness)) then {
        [_patient, true] call FUNC(setBlind);
        _patient setVariable [QGVAR(Chemical_Chlorine_Blindness), true, true];
    };
};

if (_buildup >= 100) then {
    [_patient, "Chlorine Gas Poisoning"] call ACEFUNC(medical_status,setDead);
};