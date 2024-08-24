#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle adding/removing providers from treatment text HUD element. (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Add? <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, true] call ACM_core_fnc_handleTreatmentText;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_add", true]];

if (isNull _medic || isNull _patient || {_medic == _patient}) exitWith {};

private _providerList = _patient getVariable [QGVAR(TreatmentText_Providers), []];
private _index = _providerList findIf {_x == _medic};
private _exit = false;

if (_add) then {
    if (_index > -1) then {
        _exit = true;
    } else {
        _providerList pushBack _medic;
        _patient setVariable [QGVAR(TreatmentText_Providers), _providerList];
    };
} else {
    if (_index < 0) then {
        _exit = true;
    } else {
        _providerList deleteAt _index;
        _patient setVariable [QGVAR(TreatmentText_Providers), _providerList];
    };
};

if (_exit) exitWith {};

[_patient] call FUNC(treatmentTextPFH);