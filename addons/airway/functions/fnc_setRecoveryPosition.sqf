#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle setting patient recovery position
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: State <BOOL>
 * 3: Skip <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, true] call ACM_airway_fnc_setRecoveryPosition;
 *
 * Public: No
 */

params ["_medic", "_patient", "_state", ["_skip", false]];

if (_patient getVariable [QGVAR(RecoveryPosition_State), false]) exitWith {
    ["Patient already in recovery position", 2, _medic] call ACEFUNC(common,displayTextStructured);
};

_patient setVariable [QGVAR(RecoveryPosition_State), _state, true];
_patient setVariable [QGVAR(HeadTilt_State), _state, true];
[_patient] call FUNC(updateAirwayState);

[QGVAR(handleRecoveryPosition), [_medic, _patient], _patient] call CBA_fnc_targetEvent;

if (_patient getVariable [QGVAR(AirwayObstructionVomit_State), 0] == 1) then {
    _patient setVariable [QGVAR(AirwayObstructionVomit_State), 0, true];
};

if (_patient getVariable [QGVAR(AirwayObstructionBlood_State), 0] == 1) then {
    _patient setVariable [QGVAR(AirwayObstructionBlood_State), 0, true];
};

private _hint = "Established recovery position";
private _hintLog = "%1 established recovery position";

if (_state) then {
    [_patient, "ACM_RecoveryPosition", 2] call ACEFUNC(common,doAnimation);
} else {
    _hint = "Cancelled recovery position";
    _hintLog = "%1 cancelled recovery position";
};

[_hint, 1.5, _medic] call ACEFUNC(common,displayTextStructured);

if !(_skip) then {
    [_patient, "quick_view", _hintLog, [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
};