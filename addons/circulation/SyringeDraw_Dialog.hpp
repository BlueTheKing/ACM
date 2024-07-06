#include "SyringeDraw_defines.hpp"

class RscPicture;
class RscLine;
class RscText;
class RscBackground;
class RscButton;
class RscPictureKeepAspect;
class RscControlsGroup;

class GVAR(SyringeDraw_Dialog) {
    idd = IDC_SYRINGEDRAW;
    movingEnable = 0;
    onLoad = "";
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(SyringeDraw_DLG),nil)]);
    objects[] = {};

    class ControlsBackground {
        class TopText: RscText {
            idc = IDC_SYRINGEDRAW_TEXT;
            style = ST_CENTER;
            font = "RobotoCondensed";
            x = QUOTE(safezoneX);
            y = QUOTE(safezoneY * 3);
            w = QUOTE(safezoneW);
            h = QUOTE(safezoneH);
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            text = "";
            lineSpacing = 0;
            sizeEx = QUOTE(GUI_GRID_H * 1.4);
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
            y = QUOTE(safezoneY * 2.85);
            text = "";
        };
        class Syringe_IV: RscControlsGroup {
            idc = IDC_SYRINGEDRAW_SYRINGE_IV_GROUP;
            x = QUOTE(safezoneX + (safezoneW / 10));
            y = QUOTE(safezoneY - (safezoneH / 10));
            w = QUOTE(safezoneW);
            h = QUOTE(safezoneH * 3);
            type = 15;
            style = 0;
            class ScrollBar
			{
				color[] = {1,1,1,0.6};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			};
            class HScrollbar: ScrollBar
            {
                height = 0;
                shadow = 0;
            };
            class Controls {
                class Syringe_IV_Backbit: RscPictureKeepAspect {
                    idc = -1;
                    x = 0;
                    y = 0;
                    w = QUOTE(safezoneW / 1.25);
                    h = QUOTE(safezoneH);
                    type = 0;
                    size = 0;
                    text = QPATHTOF(ui\syringe\syringe_iv_backbit_ca.paa);
                    colorText[] = {1, 1, 1, 1};
                };
                class Syringe_IV_Plunger: Syringe_IV_Backbit {
                    idc = IDC_SYRINGEDRAW_SYRINGE_IV_PLUNGER;
                    text = QPATHTOF(ui\syringe\syringe_iv_plunger_ca.paa);
                };
                class Syringe_IV_Barrel: Syringe_IV_Backbit {
                    text = QPATHTOF(ui\syringe\syringe_iv_barrel_ca.paa);
                };
            };
        };
        class Syringe_IM: RscControlsGroup {
            idc = IDC_SYRINGEDRAW_SYRINGE_IM_GROUP;
            x = QUOTE(safezoneX + (safezoneW / 10));
            y = QUOTE(safezoneY - (safezoneH / 10));
            w = QUOTE(safezoneW);
            h = QUOTE(safezoneH * 3);
            type = 15;
            style = 0;
            class ScrollBar
			{
				color[] = {1,1,1,0.6};
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
			};
            class HScrollbar: ScrollBar
            {
                height = 0;
                shadow = 0;
            };
            class Controls {
                class Syringe_IM_Backbit: RscPictureKeepAspect {
                    idc = -1;
                    x = 0;
                    y = 0;
                    w = QUOTE(safezoneW / 1.25);
                    h = QUOTE(safezoneH);
                    type = 0;
                    size = 0;
                    text = QPATHTOF(ui\syringe\syringe_im_backbit_ca.paa);
                    colorText[] = {1, 1, 1, 1};
                };
                class Syringe_IM_Plunger: Syringe_IM_Backbit {
                    idc = IDC_SYRINGEDRAW_SYRINGE_IM_PLUNGER;
                    text = QPATHTOF(ui\syringe\syringe_im_plunger_ca.paa);
                };
                class Syringe_IM_Barrel: Syringe_IM_Backbit {
                    text = QPATHTOF(ui\syringe\syringe_im_barrel_ca.paa);
                };
            };
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
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 56));
            y = QUOTE(SYRINGEDRAW_LIMIT_IV_TOP);
            w = QUOTE(safezoneW / 28);
            h = QUOTE(ACM_pxToScreen_H(36));
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            onMouseButtonUp = QUOTE(call FUNC(Syringe_Draw_Move));
            tooltip = "Move Plunger";
        };
        class Button_Draw: RscButton {
            text = "Draw";
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
            sizeEx = QUOTE(GUI_GRID_H);
            onButtonClick = QUOTE([false] call FUNC(Syringe_Draw_Button));
            tooltip = "";
        };
        class Button_Push: Button_Draw {
            text = "Push";
            idc = IDC_SYRINGEDRAW_BUTTON_PUSH;
            x = QUOTE(safezoneX + (safezoneW / 2) - ((safezoneW / 24) / 2) + ((safezoneW / 24) * 1.1));
            y = QUOTE(safezoneY + (safezoneH / 1.2));
            onButtonClick = QUOTE([true] call FUNC(Syringe_Draw_Button));
        };
    };
};
