#include "..\script_component.hpp"
/*
 * Author: Blue
 * Get airway state of patient
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * Airway State <NUMBER>
 *
 * Example:
 * [player] call ACM_airway_fnc_getAirwayState;
 *
 * Public: No
 */

params ["_patient"];

if HAS_SURGICAL_AIRWAY(_patient) exitWith {
    [1, 0.75] select (_patient getVariable [QGVAR(SurgicalAirway_TubeUnSecure), false]);
};

if !(IS_UNCONSCIOUS(_patient)) exitWith {
    1;
};

private _state = 1;

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

private _airwayInflammation = GET_AIRWAY_INFLAMMATION(_patient);

if (_airwayInflammation > 10) then {
    if (_airwayInflammation >= 100) then {
        _state = 0;
    } else {
        _state = _state * (linearConversion [10, 100, _airwayInflammation, 1, 0.2, true]);
    };
};

_state;