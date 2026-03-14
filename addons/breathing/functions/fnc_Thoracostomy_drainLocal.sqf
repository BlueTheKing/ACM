#include "..\script_component.hpp"
/*
 * Author: Blue
 * Handle draining blood from pleural space (LOCAL)
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
 * [player, cursorTarget, 0] call ACM_breathing_fnc_Thoracostomy_drainLocal;
 *
 * Public: No
 */

params ["_medic", "_patient", "_type"];

private _hint = LSTRING(ThoracostomyDrain_Complete);
private _fluid = _patient getVariable [QGVAR(Hemothorax_Fluid), 0];
private _width = 10;
private _amount = "";

if (_type != 1) then {
    _amount = switch (true) do {
        case (_fluid <= 0): {
            LSTRING(ThoracostomyDrain_Amount_None);
        };
        case (_fluid < 0.3): {
            LSTRING(ThoracostomyDrain_Amount_Small);
        };
        case (_fluid < 0.8): {
            _width = 12;
            LSTRING(ThoracostomyDrain_Amount_Significant);
        };
        default {
            LSTRING(ThoracostomyDrain_Amount_Large);
        };
    };
} else {
    if (_fluid <= 0) then {
        _amount = LSTRING(ThoracostomyDrain_Amount_None);
    } else {
        _amount = format [LLSTRING(ThoracostomyDrain_Amount_Accurate), ceil ((_fluid * 1000))];
    };
};

[_patient, "quick_view", LSTRING(ThoracostomyDrain_QuickViewLog), [_amount]] call ACEFUNC(medical_treatment,addToLog);
[QACEGVAR(common,displayTextStructured), [["%1<br/>%2", _hint, _amount], 2, _medic], _medic] call CBA_fnc_targetEvent;

_patient setVariable [QGVAR(Hemothorax_Fluid), 0, true];
[_patient] call FUNC(updateLungState);