#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set AED on patient hand (LOCAL)
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
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 0, true] call ACM_circulation_fnc_setAEDLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type", "_state"];

private _partIndex = ALL_BODY_PARTS find _bodyPart;

switch (_type) do {
    case 3: {
        _patient setVariable [QGVAR(AED_Placement_Capnograph), _state, true];

        _patient setVariable [QGVAR(AED_Capnograph_LastSync), CBA_missionTime];
        _patient setVariable [QGVAR(AED_CO2_Display), 0, true];
        _patient setVariable [QGVAR(AED_RR_Display), 0, true];
    };
    case 2: {
        _patient setVariable [QGVAR(AED_NIBP_Display), [0,0], true];

        if (_state) then {
            _patient setVariable [QGVAR(AED_Placement_PressureCuff), _partIndex, true];
        } else {
            _patient setVariable [QGVAR(AED_Placement_PressureCuff), -1, true];
        };
    };
    case 1: {
        _patient setVariable [QGVAR(AED_PulseOximeter_LastSync), CBA_missionTime];
        _patient setVariable [QGVAR(AED_PulseOximeter_Display), 0, true];

        if (_state) then {
            _patient setVariable [QGVAR(AED_Placement_PulseOximeter), _partIndex, true];
        } else {
            _patient setVariable [QGVAR(AED_Placement_PulseOximeter), -1, true];
            _patient setVariable [QGVAR(AED_PODisplay), [], true];
            _patient setVariable [QGVAR(AED_PORefreshDisplay), [], true];
        };
    };
    default {
        _patient setVariable [QGVAR(AED_Placement_Pads), _state, true];
        _patient setVariable [QGVAR(AED_Pads_LastSync), CBA_missionTime];
        _patient setVariable [QGVAR(AED_Pads_Display), 0, true];
        _patient setVariable [QGVAR(AED_ShockTotal), 0, true];

        if (_state) then {} else {
            _patient setVariable [QGVAR(AED_StartTime), -1, true];
            _patient setVariable [QGVAR(AED_EKGDisplay), [], true];
            _patient setVariable [QGVAR(AED_EKGRefreshDisplay), [], true];
        };
    };
};

if (_state) then {
    [_medic, _patient] call FUNC(handleAED);
};