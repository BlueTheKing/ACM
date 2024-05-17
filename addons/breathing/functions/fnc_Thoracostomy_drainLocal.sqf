#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle draining blood from plueral space (LOCAL)
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Device Type <NUMBER>
    * 0: Suction Bag
    * 1: ACCUVAC
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget] call ACM_breathing_fnc_Thoracostomy_drainLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_type"];

private _hint = "Fluid draining complete";
private _fluid = _patient getVariable [QGVAR(Hemothorax_Fluid), 0];
private _width = 10;
private _amount = "";

if (_type == 0) then {
    _amount = switch (true) do {
        case (_fluid <= 0): {
            "No blood drained";
        };
        case (_fluid < 0.3): {
            "Small amount of blood drained";
        };
        case (_fluid < 0.8): {
            _width = 12;
            "Significant amount of blood drained";
        };
        default {
            "Large amount of blood drained";
        };
    };
} else {
    _amount = format ["~%1 ml of blood drained", round((_fluid * 1000))];
};

[(format ["%1<br/>%2", _hint, _amount]), 2, _medic, _width] call ACEFUNC(common,displayTextStructured);

_patient setVariable [QGVAR(Hemothorax_Fluid), 0, true];