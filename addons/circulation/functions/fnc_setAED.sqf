#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set AED placement on patient
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3:  <NUMBER>
 * 4: State <BOOL>
 * 5: Hide log <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 0, true] call AMS_breathing_fnc_setAED;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type", ["_state", true], ["_hideLog", false]];

private _hint = "";

switch (_type) do {
    case 1: {
        if (_state) then {
            _hint = "connected AED Pulse Oximeter";
        } else {
            _hint = "disconnected AED Pulse Oximeter";
        };
    };
    default {
        if (_state) then {
            _hint = "applied AED pads";
        } else {
            _hint = "removed AED pads";
        };
    };
};

if !(_hideLog) then {
    [_patient, "activity", "%1 %2", [[_medic, false, true] call ACEFUNC(common,getName), _hint]] call ACEFUNC(medical_treatment,addToLog);
};

[QGVAR(setAEDLocal), [_medic, _patient, _bodyPart, _type, _state], _patient] call CBA_fnc_targetEvent;