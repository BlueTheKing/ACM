#include "SyringeDraw_defines.hpp"

class GVAR(SyringeDraw_Dialog) {
    idd = IDC_SYRINGEDRAW;
    movingEnable = 0;
    onLoad = "";
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(SyringeDraw_DLG),nil)]);
    objects[] = {};

    class ControlsBackground {
        class Syringe_10_Backbit: RscPicture {
            idc = IDC_SYRINGEDRAW_SYRINGE_10_BACKBIT;
            x = QUOTE(safeZoneX + ((safeZoneW - ACM_SYRINGEDRAW_POS_W(42)) / 2));
            y = QUOTE((safeZoneY + ((safeZoneH - ACM_SYRINGEDRAW_POS_H(42)) / 2)) - ACM_SYRINGEDRAW_POS_Y(5));
            w = QUOTE(ACM_SYRINGEDRAW_POS_W(42));
            h = QUOTE(ACM_SYRINGEDRAW_POS_H(42));
            type = 0;
            style = 48;
            size = 0;
            text = QPATHTOF(ui\syringe\syringe_10_backbit_ca.paa);
            show = 0;
        };
        class Syringe_10_Plunger: Syringe_10_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_10_PLUNGER;
            text = QPATHTOF(ui\syringe\syringe_10_plunger_ca.paa);
        };
        class Syringe_10_Barrel: Syringe_10_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_10_BARREL;
            text = QPATHTOF(ui\syringe\syringe_10_barrel_ca.paa);
        };

        class Syringe_5_Backbit: Syringe_10_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_5_BACKBIT;
            text = QPATHTOF(ui\syringe\syringe_5_backbit_ca.paa);
        };
        class Syringe_5_Plunger: Syringe_5_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_5_PLUNGER;
            text = QPATHTOF(ui\syringe\syringe_5_plunger_ca.paa);
        };
        class Syringe_5_Barrel: Syringe_5_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_5_BARREL;
            text = QPATHTOF(ui\syringe\syringe_5_barrel_ca.paa);
        };

        class Syringe_3_Backbit: Syringe_10_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_3_BACKBIT;
            text = QPATHTOF(ui\syringe\syringe_3_backbit_ca.paa);
        };
        class Syringe_3_Plunger: Syringe_3_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_3_PLUNGER;
            text = QPATHTOF(ui\syringe\syringe_3_plunger_ca.paa);
        };
        class Syringe_3_Barrel: Syringe_3_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_3_BARREL;
            text = QPATHTOF(ui\syringe\syringe_3_barrel_ca.paa);
        };

        class Syringe_1_Backbit: Syringe_10_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_1_BACKBIT;
            text = QPATHTOF(ui\syringe\syringe_1_backbit_ca.paa);
        };
        class Syringe_1_Plunger: Syringe_1_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_1_PLUNGER;
            text = QPATHTOF(ui\syringe\syringe_1_plunger_ca.paa);
        };
        class Syringe_1_Barrel: Syringe_1_Backbit {
            idc = IDC_SYRINGEDRAW_SYRINGE_1_BARREL;
            text = QPATHTOF(ui\syringe\syringe_1_barrel_ca.paa);
        };
        class TopText: RscText {
            idc = IDC_SYRINGEDRAW_TEXT;
            style = ST_CENTER;
            font = "RobotoCondensed";
            x = QUOTE(safezoneX);
            y = QUOTE(safezoneY);
            w = QUOTE(safezoneW);
            h = QUOTE(safezoneH / 10);
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            text = CSTRING(Syringe_NoMedicationSelected);
            lineSpacing = 0;
            sizeEx = QUOTE(GUI_GRID_H * 1.4 * NORMALIZE_SIZEEX);
            fixedWidth = 0;
            deletable = 0;
            fade = 0;
            access = 0;
            type = 0;
            shadow = 1;
            colorShadow[] = {0,0,0,0.5};
        };
        class BottomText: TopText {
            idc = IDC_SYRINGEDRAW_BOTTOMTEXT;
            h = QUOTE(safezoneH / 6);
            text = "";
        };
        class MedicationListSelection: TopText {
            idc = IDC_SYRINGEDRAW_MEDLIST_SELECTION_TEXT;
            sizeEx = QUOTE(GUI_GRID_H * 1.1 * NORMALIZE_SIZEEX);
            x = QUOTE(safezoneX + (safezoneW / 2) + (safezoneW / 3.05));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 4.2));
            w = QUOTE(safezoneW / 10);
            h = QUOTE(safezoneH / 25);
            text = __EVAL(call compile QUOTE(format [ARR_2(C_LLSTRING(Common_InventoryTarget),C_LLSTRING(Common_Self))]));
        };
    };
    class Controls {
        class Plunger: RscButton {
            text = "";
            colorText[] = {1,1,1,0};
            colorDisabled[] = {1,1,1,0};
            colorBackground[] = {0,0,1,0};
            colorBackgroundDisabled[] = {0,0,1,0};
            colorBackgroundActive[] = {0,0,1,0};
            colorFocused[] = {0,0,1,0};
            colorBorder[] = {0,0,0,0};
            soundClick[] = {};
            soundEnter[] = {};
            soundPush[] = {};
            soundEscape[] = {};
            idc = IDC_SYRINGEDRAW_PLUNGER;
            style = 0;
            x = QUOTE(safeZoneX + ((safeZoneW - ACM_SYRINGEDRAW_POS_W(2.78)) / 2)); //x = QUOTE(ACM_SYRINGEDRAW_POS_X(18.6));
            y = QUOTE(SYRINGEDRAW_LIMIT_10_TOP); //y = QUOTE(safeZoneY + ((safeZoneH - ACM_SYRINGEDRAW_POS_H(0.9)) / 2));
            w = QUOTE(ACM_SYRINGEDRAW_POS_W(2.78));
            h = QUOTE(ACM_SYRINGEDRAW_POS_H(0.9));
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            onMouseButtonUp = QUOTE(call FUNC(Syringe_Draw_Move));
            tooltip = "";
        };
        class Button_Draw: RscButton {
            text = CSTRING(Syringe_Draw);
            colorText[] = {1,1,1,1};
            colorDisabled[] = {1,1,1,0.1};
            colorBackground[] = {0,0,0,1};
            colorBackgroundDisabled[] = {0,0,0,0.1};
            colorBackgroundActive[] = {0,0,0,1};
            colorFocused[] = {0,0,0,1};
            colorBorder[] = {0,0,0,0};
            soundClick[] = {};
            soundEnter[] = {};
            soundPush[] = {};
            soundEscape[] = {};
            idc = IDC_SYRINGEDRAW_BUTTON_DRAW;
            style = ST_CENTER;
            x = QUOTE(safezoneX + (safezoneW / 2) - ((safezoneW / 24) / 2) - ((safezoneW / 24) * 1.1));
            y = QUOTE(safezoneY + (safezoneH / 1.2));
            w = QUOTE(safezoneW / 24);
            h = QUOTE(safezoneH / 30);
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = QUOTE(GUI_GRID_H * NORMALIZE_SIZEEX);
            onButtonClick = QUOTE([0] call FUNC(Syringe_Draw_Button));
            tooltip = "";
        };
        class Button_Inject: Button_Draw {
            text = CSTRING(Syringe_DrawInject);
            idc = IDC_SYRINGEDRAW_BUTTON_INJECT;
            x = QUOTE(safezoneX + (safezoneW / 2) - ((safezoneW / 24) / 2) + ((safezoneW / 24) * 1.1));
            w = QUOTE(safezoneW / 13);
            onButtonClick = QUOTE([2] call FUNC(Syringe_Draw_Button));
        };
        class Button_Push: Button_Inject {
            text = CSTRING(Syringe_DrawPush);
            idc = IDC_SYRINGEDRAW_BUTTON_PUSH;
            y = QUOTE(safezoneY + (safezoneH / 1.14));
            onButtonClick = QUOTE([1] call FUNC(Syringe_Draw_Button));
            show = 0;
        };
        class SwitchTargetInventory: RscButtonMenu {
            idc = IDC_SYRINGEDRAW_MEDLIST_SELECTION_BUTTON;
            x = QUOTE(safezoneX + (safezoneW / 2) + (safezoneW / 3.1));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 4.3));
            w = QUOTE(safezoneW / 65);
            h = QUOTE(safezoneH / 35);
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            action = QUOTE(call FUNC(Syringe_SwitchTargetInventory));
            textureNoShortcut = QPATHTOF(ui\transfusionmenu\inventory_select_ca.paa);
            tooltip = CSTRING(Common_SwitchTargetInventory);
            colorBackground[] = {1,1,1,0};
            colorBackgroundFocused[] = {1,1,1,0};
            color[] = {1,0,0,1};
            period = 0;
            periodFocus = 0;
            periodOver = 0;
            class ShortcutPos
            {
                left = 0;
                top = 0;
                w = QUOTE(safezoneW / 55);
                h = QUOTE(safezoneH / 30);
            };
        };
        class MedicationListPanel: RscListBox
        {
            idc = IDC_SYRINGEDRAW_MEDLIST;
            x = QUOTE(safezoneX + (safezoneW / 2) + (safezoneW / 3.3));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 5.3));
            w = QUOTE(safezoneW / 6.5);
            h = QUOTE(safezoneH / 2.5);
            rowHeight = QUOTE(safezoneH / 20);
            colorText[] = {1,1,1,1};
            colorSelect[] = {0,0,0,1};
            colorSelect2[] = {0,0,0,1};
            colorBackground[] = {0,0,0,0.1};
            colorSelectBackground[] = {0.7,0.7,0.7,1};
            colorSelectBackground2[] = {0.7,0.7,0.7,1};
            sizeEx = QUOTE(GUI_GRID_H * 0.9 * NORMALIZE_SIZEEX);
            class Items {};
        };
    };
};
