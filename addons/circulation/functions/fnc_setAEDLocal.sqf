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
 * 4: State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", 0, true] call AMS_circulation_fnc_setAEDLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_type", "_state"];

private _partIndex = ALL_BODY_PARTS find _bodyPart;

switch (_type) do {
    case 1: {
        _patient setVariable [QGVAR(AED_PulseOximeter_LastSync), CBA_missionTime];
        _patient setVariable [QGVAR(AED_PulseOximeter_Display), 0, true];

        if (_state) then {
            _patient setVariable [QGVAR(AED_Placement_PulseOximeter), _partIndex, true];
            [_medic, _patient] call FUNC(handleAED);
        } else {
            _patient setVariable [QGVAR(AED_Placement_PulseOximeter), -1, true];
        };
    };
    default {
        _patient setVariable [QGVAR(AED_Placement_Pads), _state, true];
        _patient setVariable [QGVAR(AED_Pads_LastSync), CBA_missionTime];
        _patient setVariable [QGVAR(AED_Pads_Display), 0, true];
        _patient setVariable [QGVAR(AED_ShockTotal), 0, true];

        if (_state) then {
            [_medic, _patient] call FUNC(handleAED);
        };
    };
};