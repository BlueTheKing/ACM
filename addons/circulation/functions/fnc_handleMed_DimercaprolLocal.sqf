#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle Dimercaprol effects (LOCAL)
 *
 * Arguments:
 * 0: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call ACM_circulation_fnc_handleMed_DimercaprolLocal;
 *
 * Public: No
 */

params ["_patient"];

if (_patient getVariable [QGVAR(Dimercaprol_PFH), -1] != -1) exitWith {};

private _PFH = [{
    params ["_args", "_idPFH"];
    _args params ["_patient"];

    private _dose = ([_patient, "Dimercaprol", false] call ACEFUNC(medical_status,getMedicationCount));

    if (!(alive _patient) || _dose < 0.1) exitWith {
        _patient setVariable [QGVAR(Dimercaprol_PFH), -1];
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (_dose < 0.5) exitWith {};

    private _reduce = 8 * (_dose min 2);
    _reduce = ([_reduce, (_reduce / 2)] select (IN_CRDC_ARRST(_patient)));

    private _buildup = _patient getVariable [QGVAR_BUILDUP(Chemical_Lewisite), 0];
    _patient setVariable [QGVAR_BUILDUP(Chemical_Lewisite), ((_buildup - _reduce) max 0), true];
}, (20 + (random 10)), [_patient]] call CBA_fnc_addPerFrameHandler;

_patient setVariable [QGVAR(Dimercaprol_PFH), _PFH];