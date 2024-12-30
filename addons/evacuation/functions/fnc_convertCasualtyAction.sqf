#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle action to perform casualty conversion.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_evacuation_fnc_convertCasualtyAction;
 *
 * Public: No
 */

params ["_medic", "_patient"];

if (isNull (objectParent _medic)) then {
    [_medic] call ACEFUNC(common,goKneeling);
};

[3, [_medic, _patient], {
    params ["_args"];
    _args params ["_medic", "_patient"];

    if !([_medic, _patient] call FUNC(canConvert)) exitWith {
        [LLSTRING(ConvertCasualty_Failed), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
    };

    [_medic, _patient] call FUNC(convertCasualty);
    [LLSTRING(ConvertCasualty_InProgress), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
}, {
    params ["_args"];
    _args params ["_medic", "_patient"];

    [LLSTRING(ConvertCasualty_Cancelled), 1.5, _medic] call ACEFUNC(common,displayTextStructured);
}, LLSTRING(ConvertCasualty_Progress), {true}, ["isNotInside"]] call ACEFUNC(common,progressBar);