#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if patient has AED connected
 *
 * Arguments:
 * 0: Patient <OBJECT>
 * 1: Body Part <STRING>
 * 2: Type <NUMBER>
    * 0: Any
    * 1: Pads
    * 2: Pulse Oximeter
    * 3: Pressure Cuff
    * 4: Capnograph
 *
 * Return Value:
 * Has AED <BOOL>
 *
 * Example:
 * [cursorTarget, "leftarm", 0] call ACM_circulation_fnc_hasAED;
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
private _pressureCuffPlacement = _patient getVariable [QGVAR(AED_Placement_PressureCuff), -1];
private _capnographStatus = _patient getVariable [QGVAR(AED_Placement_Capnograph), false];

switch (_type) do {
    case 4: {
        _capnographStatus;
    };
    case 3: {
        if (_pressureCuffPlacement != -1) then {
            if (_bodyPart == "") then {
                true;
            } else {
                _pressureCuffPlacement == _partIndex;
            };
        } else {
            false;
        };
    };
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
    default {_padsStatus || _pulseOximeterPlacement != -1 || _pressureCuffPlacement != -1 || _capnographStatus};
};