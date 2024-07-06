#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle airway collapse due to loss of reflexes.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_airway_fnc_handleAirwayCollapse;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(AirwayCollapse_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _keepAirwayIntact = false;
    private _collapseState = _patient getVariable [QGVAR(AirwayCollapse_State), 0];

    if (!(IS_UNCONSCIOUS(_patient)) || _collapseState > 2) exitWith {
        _patient setVariable [QGVAR(AirwayCollapse_State), 3, true];
        _patient setVariable [QGVAR(AirwayCollapse_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (_keepAirwayIntact) exitWith {};

    if (random 1 < (0.3 * GVAR(airwayCollapseChance))) then {
        _patient setVariable [QGVAR(AirwayCollapse_State), (_collapseState + 1), true];
        [_patient] call FUNC(updateAirwayState);
    };

}, (30 + (random 15)), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AirwayCollapse_PFH), _PFH];