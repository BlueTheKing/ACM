#include "..\script_component.hpp"
/*
 * Author: Blue
 * Wash eyes of patient with water.
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Used Item <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorTarget, ""] call ACM_CBRN_fnc_washEyes;
 *
 * Public: No
 */

params ["_medic", "_patient", ["_usedItem", ""]];

if (_usedItem != "") then {
    private _item = switch (_usedItem) do {
        case "ACE_WaterBottle": {"ACE_WaterBottle_Half"};
        case "ACE_WaterBottle_Half": {"ACE_WaterBottle_Empty"};
        case "ACE_Canteen": {"ACE_Canteen_Half"};
        case "ACE_Canteen_Half": {"ACE_Canteen_Empty"};
    };

    [_medic, _item] call ACEFUNC(common,addToInventory);
};

[LLSTRING(WashEyes_Complete), 2, _unit] call ACEFUNC(common,displayTextStructured);
[_patient, "activity", LLSTRING(WashEyes_ActionLog), [[_medic, false, true] call ACEFUNC(common,getName)]] call ACEFUNC(medical_treatment,addToLog);

_patient setVariable [QGVAR(EyesWashed), true, true];

[_patient, false] call FUNC(setBlind);