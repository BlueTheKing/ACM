#include "..\script_component.hpp"
/*
 * Author: Blue
 * Set pulse oximeter placement on patient hand (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: State <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, "leftarm", true] call ACM_breathing_fnc_setPulseOximeterLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart", "_state"];

private _partIndex = ALL_BODY_PARTS find _bodyPart;
private _pulseOxIndex = _partIndex - 2;
private _placementState = GET_PULSEOX(_patient);

_placementState set [_pulseOxIndex, _state];

_patient setVariable [QGVAR(PulseOximeter_Placement), _placementState, true];

if (_state) then {
    // Delay so pulse oximeter takes time to "calibrate"
    private _lastSyncArray = _patient getVariable [QGVAR(PulseOximeter_LastSync), [-1,-1]];
    _lastSyncArray set [_pulseOxIndex, CBA_missionTime];
    _patient setVariable [QGVAR(PulseOximeter_LastSync), _lastSyncArray];

    [_medic, _patient, _partIndex] call FUNC(handlePulseOximeter);
} else {
    private _displayArray = _patient getVariable [QGVAR(PulseOximeter_Display), [[0,0],[0,0]]];
    _displayArray set [_pulseOxIndex, [0,0]];
    _patient setVariable [QGVAR(PulseOximeter_Display), _displayArray, true];
};