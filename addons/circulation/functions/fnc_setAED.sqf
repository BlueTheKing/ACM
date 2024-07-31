#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set AED placement on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Type <NUMBER>
    * 0: Pads
    * 1: Pulse Oximeter
    * 2: Pressure Cuff
    * 3: Capnograph
 * 4: State <BOOL>
 * 5: Hide log <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 0, true] call ACM_circulation_fnc_setAED;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type", ["_state", true], ["_hideLog", false]];

if !([_medic,_patient] call FUNC(canConnectAED)) exitWith {};

private _hint = "";

switch (_type) do {
    case 3: {
        if (_state) then {
            _hint = format ["%1 %2", (toLower LELSTRING(core,Common_Connected)), LLSTRING(AED_Capnograph)];
        } else {
            _hint = format ["%1 %2", (toLower LELSTRING(core,Common_Disconnected)), LLSTRING(AED_Capnograph)];
        };
    };
    case 2: {
        if (_state) then {
            _hint = format ["%1 %2", (toLower LELSTRING(core,Common_Connected)), LLSTRING(AED_PressureCuff)];
        } else {
            _hint = format ["%1 %2", (toLower LELSTRING(core,Common_Disconnected)), LLSTRING(AED_PressureCuff)];
        };
    };
    case 1: {
        if (_state) then {
            _hint = format ["%1 %2", (toLower LELSTRING(core,Common_Connected)), LLSTRING(AED_PulseOximeter)];
        } else {
            _hint = format ["%1 %2", (toLower LELSTRING(core,Common_Disconnected)), LLSTRING(AED_PulseOximeter)];
        };
    };
    default {
        if (_state) then {
            _hint = format ["%1 %2", (toLower LELSTRING(core,Common_Applied)), LLSTRING(AED_Pads)];
        } else {
            _hint = format ["%1 %2", (toLower LELSTRING(core,Common_Removed)), LLSTRING(AED_Pads)];
        };
    };
};

if (_state && [_patient, _bodyPart, (_type + 1)] call FUNC(hasAED)) exitWith {
    [(format [LLSTRING(AED_Already), _hint, toLower ([_bodyPart] call EFUNC(core,getBodyPartString))]), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

if !(_hideLog) then {
    [_patient, "activity", "%1 %2", [[_medic, false, true] call ACEFUNC(common,getName), _hint]] call ACEFUNC(medical_treatment,addToLog);
};

[QGVAR(setAEDLocal), [_medic, _patient, _bodyPart, _type, _state], _patient] call CBA_fnc_targetEvent;