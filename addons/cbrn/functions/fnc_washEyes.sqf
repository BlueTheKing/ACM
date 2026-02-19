#include "..\script_component.hpp"
/*
 * Author: Blue
 * Wash eyes of patient with water.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Used Item <STRING>
 * 3: Water Source Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, ""] call ACM_CBRN_fnc_washEyes;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_usedItem", ""], ["_sourceObject", objNull]];

if (_usedItem != "") then {
    private _item = switch (_usedItem) do {
        case "ACE_WaterBottle": {"ACE_WaterBottle_Half"};
        case "ACE_WaterBottle_Half": {"ACE_WaterBottle_Empty"};
        case "ACE_Canteen": {"ACE_Canteen_Half"};
        case "ACE_Canteen_Half": {"ACE_Canteen_Empty"};
    };

    [_medic, _item] call ACEFUNC(common,addToInventory);
};

if !(isNull _sourceObject) then {
    private _waterSource = _sourceObject getVariable [QACEGVAR(field_rations,waterSource), objNull];
    private _waterRemaining = _waterSource call ACEFUNC(field_rations,getRemainingWater);
    [_waterSource, (_waterRemaining - 1) max 0] call ACEFUNC(field_rations,setRemainingWater);
};

if (_medic != _patient) then {
    [(format [LLSTRING(WashEyes_Complete_Other), [_patient, false, true] call ACEFUNC(common,getName)]), 2, _medic] call ACEFUNC(common,displayTextStructured);
    [QACEGVAR(common,displayTextStructured), [(format [LLSTRING(WashEyes_Complete_Self), [_medic, false, true] call ACEFUNC(common,getName)]), 2, _patient], _patient] call CBA_fnc_targetEvent;
} else {
    [LLSTRING(WashEyes_Complete), 1.5, _patient] call ACEFUNC(common,displayTextStructured);
};
[_patient, "activity", LLSTRING(WashEyes_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

_patient setVariable [QGVAR(EyesWashed), true, true];

if ((_patient getVariable [QGVAR(Chemical_Chlorine_Blindness), false]) || (_patient getVariable [QGVAR(Chemical_Lewisite_Blindness), false])) exitWith {};

[_patient, false] call FUNC(setBlind);