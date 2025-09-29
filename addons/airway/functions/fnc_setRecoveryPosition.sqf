#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle setting patient recovery position.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: State <BOOL>
 * 3: No Log <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, true] call ACM_airway_fnc_setRecoveryPosition;
 *
 * Public: No
 */

params ["_medic", "_patient", "_state", ["_noLog", false]];

if (_state && _patient getVariable [QGVAR(RecoveryPosition_State), false]) exitWith {
    [LSTRING(RecoveryPosition_Already), 2, _medic] call ACEFUNC(common,displayTextStructured);
};

if ((!_state && !(_patient getVariable [QGVAR(RecoveryPosition_State), false])) || !(IS_UNCONSCIOUS(_patient))) exitWith {};

_patient setVariable [QGVAR(RecoveryPosition_State), _state, true];
_patient setVariable [QGVAR(HeadTilt_State), _state, true];

if (_patient getVariable [QGVAR(AirwayObstructionVomit_State), 0] == 1) then {
    _patient setVariable [QGVAR(AirwayObstructionVomit_State), 0, true];
};

if (_patient getVariable [QGVAR(AirwayObstructionBlood_State), 0] == 1) then {
    _patient setVariable [QGVAR(AirwayObstructionBlood_State), 0, true];
};

private _hint = LSTRING(RecoveryPosition_Established);
private _hintLog = LSTRING(RecoveryPosition_Established_ActionLog);

if (_state) then {
    [QGVAR(handleRecoveryPosition), [_medic, _patient], _patient] call CBA_fnc_targetEvent;
    [_patient, "ACM_RecoveryPosition", 2] call ACEFUNC(common,doAnimation);
} else {
    _hint = LSTRING(RecoveryPosition_Cancelled);
    _hintLog = LSTRING(RecoveryPosition_Cancelled_ActionLog);
};

[_hint, 1.5, _medic] call ACEFUNC(common,displayTextStructured);

if !(_noLog) then {
    [_patient, "quick_view", _hintLog, [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);
};