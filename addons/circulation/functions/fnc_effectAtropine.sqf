#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle atropine effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_effectAtropine;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(Atropine_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _dose = [_patient, "Atropine"] call FUNC(getMedicationConcentration);

    if (!(alive _patient) || _dose < 1) exitWith {
        _patient setVariable [QGVAR(Atropine_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (_dose < 3) exitWith {};

    private _reduce = 2 * (_dose / 3);
    _reduce = ([_reduce, (_reduce / 2)] select (IN_CRDC_ARRST(_patient)));

    private _buildup = _patient getVariable [QGVAR_BUILDUP(Chemical_Sarin), 0];
    _patient setVariable [QGVAR_BUILDUP(Chemical_Sarin), ((_buildup - _reduce) max 0), true];

    if (_dose < 4) exitWith {};

    if (HAS_AIRWAY_SPASM(_patient) && ((random 1 < 0.3) || _buildup <= 1)) then {
        _patient setVariable [QGVAR(AirwaySpasm), false, true];
    };
}, (20 + (random 10)), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Atropine_PFH), _PFH];