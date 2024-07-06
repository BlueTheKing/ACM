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
 * [player] call ACM_airway_fnc_handleAirwayObstruction_Vomit;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(AirwayObstructionVomit_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _inRecovery = _patient getVariable [QGVAR(RecoveryPosition_State), false];
    private _keepAirwayIntact = (_patient getVariable [QGVAR(AirwayItem_Oral), ""] == "SGA"); // TODO consciousness state
    private _gracePeriod = (_patient getVariable [QGVAR(AirwayObstructionVomit_GracePeriod), -1]) + 10 > CBA_missionTime;
    private _obstructionState = _patient getVariable [QGVAR(AirwayObstructionVomit_State), 0];
    private _vomitCount = _patient getVariable [QGVAR(AirwayObstructionVomit_Count), 0];

    if (!(IS_UNCONSCIOUS(_patient)) || _vomitCount < 1) exitWith {
        if (_vomitCount < 1) then {
            _patient setVariable [QGVAR(AirwayObstructionVomit_Count), 0, true];
        };
        _patient setVariable [QGVAR(AirwayObstructionVomit_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (_keepAirwayIntact || _gracePeriod) exitWith {};

    if (random 1 < (0.3 * GVAR(airwayObstructionVomitChance))) then {
        _patient setVariable [QGVAR(AirwayObstructionVomit_Count), (_vomitCount - 1), true];

        if !(_inRecovery) then { // TODO check for pose
            _patient setVariable [QGVAR(AirwayObstructionVomit_State), (_obstructionState + 1), true];
            [_patient] call FUNC(updateAirwayState);
        };

        playSound3D [format ["%1%2.wav", QPATHTOF(sound\vomit),(1 + round(random 5))], _patient, false, getPosASL _patient, 10, (0.9 + (random 0.2)), 10];
    };
}, (35 + (random 15)), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AirwayObstructionVomit_PFH), _PFH];