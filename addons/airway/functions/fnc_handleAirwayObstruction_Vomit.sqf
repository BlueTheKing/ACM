#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle airway obstruction due to vomit.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_airway_fnc_handleAirwayObstruction_Vomit;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(AirwayObstructionVomit_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _inRecovery = _patient getVariable [QGVAR(RecoveryPosition_State), false];
    private _keepAirwayIntact = (_patient getVariable [QGVAR(AirwayItem), ""] == "SGA"); // TODO consciousness state
    private _gracePeriod = (_patient getVariable [QGVAR(AirwayObstructionVomit_GracePeriod), -1]) + 10 > CBA_missionTime;
    private _obstructionState = _patient getVariable [QGVAR(AirwayObstructionVomit_State), 0];
    private _vomitCount = _patient getVariable [QGVAR(AirwayObstructionVomit_Count), 0];

    if (!(IS_UNCONSCIOUS(_patient)) || _vomitCount <= 0) exitWith {
        _patient setVariable [QGVAR(AirwayObstructionVomit_Count), 0, true];
        _patient setVariable [QGVAR(AirwayObstructionVomit_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (_keepAirwayIntact || _gracePeriod) exitWith {};

    if (random 100 < (50 * GVAR(airwayObstructionVomitChance))) then {
        // TODO play noise
        _patient setVariable [QGVAR(AirwayObstructionVomit_Count), (_vomitCount - 1), true];

        if !(_inRecovery) then { // TODO check for pose
            _patient setVariable [QGVAR(AirwayObstructionVomit_State), (_obstructionState + 1), true];
            [_patient] call FUNC(updateAirwayState);
        };
    };

}, (25 + (random 10)), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AirwayObstructionVomit_PFH), _PFH];