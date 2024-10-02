#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle add bag button.
 *
 * Arguments:
 * 0: Arguments <ARRAY>
 * 1: On Complete <CODE>
 * 2: On Cancel <CODE>
 * 3: Text <STRING>
 * 4: Time <NUMBER>
 * 5: Use Condition <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[_medic, _patient], {}, {}, "", 5, false] call ACM_core_fnc_progressBarAction;
 *
 * Public: No
 */

params ["_args", "_onComplete", "_onCancel", "_text", "_time", ["_condition", false]];
_args params ["_medic", "_patient"];

private _inVehicle = !(isNull objectParent _medic);

if (!_inVehicle && stance _medic in ["STAND","CROUCH"]) then {
    _medic call ACEFUNC(common,goKneeling);
};

[_time, [_args, [_inVehicle, _onComplete, _onCancel]], {
    params ["_allArgs"];
    _allArgs params ["_args", "_extraArgs"];
    _extraArgs params ["", "_onComplete"];
    _args call _onComplete;
}, {
    params ["_allArgs"];
    _allArgs params ["_args", "_extraArgs"];
    _extraArgs params ["", "", "_onCancel"];
    _args call _onCancel;
}, _text, 
([{
    params ["_allArgs"];
    _allArgs params ["_args", "_extraArgs"];
    _args params ["_medic", "_patient"];
    _extraArgs params ["_inVehicle"];

    private _patientCondition = !(_patient isEqualTo objNull);
    private _medicCondition = ((alive _medic) && !(IS_UNCONSCIOUS(_medic)) && !(_medic isEqualTo objNull));
    private _vehicleCondition = (objectParent _medic isEqualTo objectParent _patient);
    private _distanceCondition = (_patient distance2D _medic <= ACEGVAR(medical_gui,maxDistance));

    (_patientCondition && _medicCondition && ((_inVehicle && _vehicleCondition) || (!_inVehicle && _distanceCondition)));
}, {true}] select _condition), ["isNotInside", "isNotSwimming", "isNotInZeus"]] call ACEFUNC(common,progressBar);