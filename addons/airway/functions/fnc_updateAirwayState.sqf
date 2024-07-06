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
 * [player] call ACM_airway_fnc_updateAirwayState;
 *
 * Public: No
 */

params ["_patient"];

private _state = 1;

if !(IS_UNCONSCIOUS(_patient)) exitWith {
    _patient setVariable [QGVAR(AirwayState), _state, true];
};

private _airwayReflex = _patient getVariable [QGVAR(AirwayReflex_State), false];

if (((_patient getVariable [QGVAR(AirwayObstructionVomit_State), 0]) + (_patient getVariable [QGVAR(AirwayObstructionBlood_State), 0])) > 0) then {
    _state = 0;
} else {
    private _collapseState = 1 - ((_patient getVariable [QGVAR(AirwayCollapse_State), 0]) / 3);
    private _airwayState = [0.78, 0.88] select (_airwayReflex);
    
    private _airwayItemOral = _patient getVariable [QGVAR(AirwayItem_Oral), ""];
    private _airwayItemNasal = _patient getVariable [QGVAR(AirwayItem_Nasal), ""];

    switch (true) do {
        case (_patient getVariable [QGVAR(RecoveryPosition_State), false]): {
            _state = _collapseState max 0.97;
        };
        case (_patient getVariable [QGVAR(HeadTilt_State), false]): {
            _state = _collapseState max 0.98;
        };
        case (_airwayItemOral == "SGA"): {
            _state = _collapseState max 0.99;
        };
        case (_airwayItemNasal == "NPA");
        case (_airwayItemOral == "OPA"): {
            _state = _collapseState min (_airwayState max 0.95);
        };
        default {
            _state = _airwayState min _collapseState;
        };
    };
};

_patient setVariable [QGVAR(AirwayState), _state, true];