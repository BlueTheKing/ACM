#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle airway obstruction due to bleeding.
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_airway_fnc_handleAirwayObstruction_Blood;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(AirwayObstructionBlood_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _isBleeding = [_patient, "head"] call EFUNC(damage,isBodyPartBleeding);
    private _inRecovery = _patient getVariable [QGVAR(RecoveryPosition_State), false];

    if (!(IS_UNCONSCIOUS(_patient)) || !_isBleeding) exitWith {
        _patient setVariable [QGVAR(AirwayObstructionBlood_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (_inRecovery) exitWith {}; // TODO check for pose

    private _cardiacArrest = GET_HEART_RATE(_patient) < 20;
    private _obstructChance = (linearConversion [0.05, 0.5, ([_patient, "head"] call EFUNC(damage,getBodyPartBleeding)), 0, 0.5, true]) * GVAR(airwayObstructionBloodChance);
    private _obstructionState = _patient getVariable [QGVAR(AirwayObstructionBlood_State), 0];

    if ((!_cardiacArrest && (random 1 < _obstructChance)) || {_cardiacArrest && (random 1 < (_obstructChance / 2))}) then {
        _patient setVariable [QGVAR(AirwayObstructionBlood_State), (_obstructionState + 1), true];
        [_patient] call FUNC(updateAirwayState);
    };

}, 5 max (random 10), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AirwayObstructionBlood_PFH), _PFH];