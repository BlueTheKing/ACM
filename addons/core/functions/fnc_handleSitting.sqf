#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle patient in sitting position. (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_core_fnc_handleSitting;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(Sitting_State_PFH), -1] != -1) exitWith {};

_patient setVariable [QGVAR(Sitting_State), true, true];

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    if (animationState _patient != "amovpsitmstpsnonwnondnon_ground" || IS_UNCONSCIOUS(_patient)) exitWith {
        _patient setVariable [QGVAR(Sitting_State), false, true];
        _patient setVariable [QGVAR(Sitting_State_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

}, 0.5, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Sitting_State_PFH), _PFH];