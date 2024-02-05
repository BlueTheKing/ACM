#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle reversible cardiac arrest
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call AMS_circulation_fnc_handleReversibleCardiacArrest;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(ReversibleCardiacArrest_PFH), -1] != -1) exitWith {};

_patient setVariable [QGVAR(ReversibleCardiacArrest_State), true, true];
_patient setVariable [QGVAR(ReversibleCardiacArrest_Time), CBA_missionTime];
_patient setVariable [QGVAR(CardiacArrest_RhythmState), 5, true];

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _time = _patient getVariable [QGVAR(ReversibleCardiacArrest_Time), -1];

    private _reversibleCause = _patient getVariable [QGVAR(TensionPneumothorax_State), false] || (BLOOD_VOLUME_CLASS_4_HEMORRHAGE >= GET_BLOOD_VOLUME(_patient)) || (GET_OXYGEN(_patient) < 70);

    if (!_reversibleCause || !(IN_CRDC_ARRST(_patient)) || !(alive _patient) || ((_time + 600) < CBA_missionTime)) exitWith {
        _patient setVariable [QGVAR(ReversibleCardiacArrest_State), false, true];

        if (IN_CRDC_ARRST(_patient) && (alive _patient) && ((_time + 600) > CBA_missionTime)) then {
            _patient setVariable [QGVAR(CardiacArrest_RhythmState), 0, true];
            [QACEGVAR(medical,CPRSucceeded), _patient] call CBA_fnc_localEvent;
        };

        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
}, 5, [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(ReversibleCardiacArrest_PFH), _PFH];