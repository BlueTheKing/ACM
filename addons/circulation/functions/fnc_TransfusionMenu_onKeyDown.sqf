#include "..\script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"
/*
 * Author: Blue
 * Handle keyboard inputs in transfusion menu.
 *
 * Arguments:
 * 1: Args <ARRAY>
 * - 0: Menu display <DISPLAY>
 * - 1: Key being pressed <NUMBER>
 * - 2: Shift state <BOOL>
 * - 3: Ctrl state <BOOL>
 * - 4: Alt state <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["", [displayNull, 5, false, false, false]] call ACM_circulation_fnc_TransfusionMenu_onKeyDown;
 *
 * Public: No
*/

params ["", "_args"];
_args params ["_display", "_keyPressed", "_shiftState", "_ctrlState", "_altState"];

switch (_keyPressed) do {
    case DIK_1: {
        if !(GVAR(TransfusionMenu_SelectIV)) then {
            GVAR(TransfusionMenu_SelectIV) = true;
        };
        ["", 0] call FUNC(TransfusionMenu_SelectBodyPart);
    };
    case DIK_2: {
        if !(GVAR(TransfusionMenu_SelectIV)) then {
            GVAR(TransfusionMenu_SelectIV) = true;
        };
        ["", 1] call FUNC(TransfusionMenu_SelectBodyPart);
    };
    case DIK_3: {
        if !(GVAR(TransfusionMenu_SelectIV)) then {
            GVAR(TransfusionMenu_SelectIV) = true;
        };
        ["", 2] call FUNC(TransfusionMenu_SelectBodyPart);
    };
    case DIK_Q: {
        [] call FUNC(TransfusionMenu_ToggleIV);
    };
    case DIK_E: {
        [] call FUNC(TransfusionMenu_SwitchTargetInventory);
    };
    case DIK_W: {
        ["head", 0] call FUNC(TransfusionMenu_SelectBodyPart);
    };
    case DIK_S: {
        ["body", 0] call FUNC(TransfusionMenu_SelectBodyPart);
    };
    case DIK_D: {
        ["leftarm", 0] call FUNC(TransfusionMenu_SelectBodyPart);
    };
    case DIK_A: {
        ["rightarm", 0] call FUNC(TransfusionMenu_SelectBodyPart);
    };
    case DIK_X: {
        ["leftleg", 0] call FUNC(TransfusionMenu_SelectBodyPart);
    };
    case DIK_Z: {
        ["rightleg", 0] call FUNC(TransfusionMenu_SelectBodyPart);
    };
    default {};
};
