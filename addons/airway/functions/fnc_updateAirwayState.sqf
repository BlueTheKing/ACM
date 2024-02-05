#include "..\script_component.hpp"
/*
 * Author: Blue
 * Update airway state of patient
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_airway_fnc_updateAirwayState;
 *
 * Public: No
 */

params ["_patient"];

private _state = 1;

if (((_patient getVariable [QGVAR(AirwayObstructionVomit_State), 0]) + (_patient getVariable [QGVAR(AirwayObstructionBlood_State), 0])) > 0) then {
    _state = 0;
} else {
    private _collapseState = 1 - ((_patient getVariable [QGVAR(AirwayCollapse_State), 0]) / 3);
    
    if (_patient getVariable [QGVAR(AirwayItem), ""] != "") then {
        _state = _collapseState max 0.95;
	} else {
        if (_patient getVariable [QGVAR(HeadTilt_State), false]) then {
            if (_patient getVariable [QGVAR(RecoveryPosition_State), false]) then {
                _state = _collapseState max 0.8;
            } else {
                _state = _collapseState max 0.75;
            };
        } else {
            _state = _collapseState;
        };
    };
};

_patient setVariable [QGVAR(AirwayState), _state, true];