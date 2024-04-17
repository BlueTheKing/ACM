#include "..\script_component.hpp"
/*
 * Author: Blue
 * Check if patient has AED connected
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Type <NUMBER>
 *
 * Return Value:
 * Has AED <BOOL>
 *
 * Example:
 * [player, cursorTarget, "leftarm", 0] call AMS_circulation_fnc_hasAED;
 *
 * Public: No
 */

params [["_medic", objNull], "_patient", ["_bodyPart", ""], ["_type", 0]];

if !(isNull _medic) then {
    private _AEDPatient = _medic getVariable [QGVAR(AED_Target_Patient), objNull];

    if (_type != -1 && {alive _AEDPatient}) exitWith {_AEDPatient != _patient};
};

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