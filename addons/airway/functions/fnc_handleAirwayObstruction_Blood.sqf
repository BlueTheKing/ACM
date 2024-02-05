#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle airway obstruction due to blood.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_airway_fnc_handleAirwayObstruction_Blood;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(AirwayObstructionBlood_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _isBleeding = false;
    private _cardiacArrest = false;
    private _inRecovery = false;
    private _obstructionState = _patient getVariable [QGVAR(AirwayObstructionBlood_State), 0];

    if (!(IS_UNCONSCIOUS(_patient)) || _isBleeding) exitWith {
        _patient setVariable [QGVAR(AirwayObstructionBlood_Count), 0, true];
        _patient setVariable [QGVAR(AirwayObstructionBlood_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if !(_isBleeding) exitWith {};

    if ((!_cardiacArrest && (random 100 < 50)) || {(_cardiacArrest && (random 100 < 20))}) then { // TODO settable chance
        if !(_inRecovery) then {
            _patient setVariable [QGVAR(AirwayObstructionBlood_State), (_obstructionState + 1), true];
            [_patient] call FUNC(updateAirwayState);
        };
    };

}, 2 max (random 10), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AirwayObstructionBlood_PFH), _PFH];