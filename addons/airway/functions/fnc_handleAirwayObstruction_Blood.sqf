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

    private _isBleeding = [_patient, "head"] call EFUNC(damage,isBodyPartBleeding);
    private _inRecovery = _patient getVariable [QGVAR(RecoveryPosition_State), false];

    if (!(IS_UNCONSCIOUS(_patient)) || !_isBleeding) exitWith {
        if !(IS_UNCONSCIOUS(_patient)) then {
            _patient setVariable [QGVAR(AirwayObstructionBlood_Count), 0, true];
        };
        _patient setVariable [QGVAR(AirwayObstructionBlood_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (_inRecovery) exitWith {};

    private _cardiacArrest = IN_CRDC_ARRST(_patient);
    private _obstructChance = linearConversion [0.05, 0.5, ([_patient, "head"] call EFUNC(damage,getBodyPartBleeding)), 0, 50, true];
    private _obstructionState = _patient getVariable [QGVAR(AirwayObstructionBlood_State), 0];

    if ((!_cardiacArrest && (random 100 < _obstructChance)) || {(_cardiacArrest && (random 100 < (_obstructChance * 0.4)))}) then { // TODO settable chance
        _patient setVariable [QGVAR(AirwayObstructionBlood_State), (_obstructionState + 1), true];
        [_patient] call FUNC(updateAirwayState);
    };

}, 2 max (random 8), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(AirwayObstructionBlood_PFH), _PFH];