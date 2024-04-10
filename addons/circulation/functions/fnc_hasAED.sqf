#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if patient has AED connected
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Type <NUMBER>
 *
 * Return Value:
 * Has AED <BOOL>
 *
 * Example:
 * [cursorTarget, "leftarm"] call AMS_circulation_fnc_hasAED;
 *
 * Public: No
 */

params ["_patient", ["_bodyPart", ""], ["_type", 0]];

private _partIndex = "";
if (_bodyPart != "") then {
    _partIndex = ALL_BODY_PARTS find _bodyPart;
};

private _padsStatus = _patient getVariable [QGVAR(AED_Placement_Pads), false];
private _pulseOximeterPlacement = _patient getVariable [QGVAR(AED_Placement_PulseOximeter), -1];

switch (_type) do {
    case 2: {
        if (_pulseOximeterPlacement != -1) then {
            if (_bodyPart == "") then {
                true;
            } else {
                _pulseOximeterPlacement == _partIndex;
            };
        } else {
            false;
        };
    };
    case 1: {
        _padsStatus;
    };
    default {_padsStatus || _pulseOximeterPlacement != -1};
};