#include "MeasureBP_defines.hpp"

class RscPicture;
class RscPictureKeepAspect;
class RscText;
class RscLine;

class GVAR(MeasureBP_Dialog)
{
    idd = IDC_MEASUREBP;
    movingEnable = 0;
    onLoad = "";
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(MeasureBP_DLG),nil)]);
    objects[] = {};
    class ControlsBackground {
        class BodyBackground: RscPictureKeepAspect {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW * 1.3));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH));
            w = QUOTE(safezoneW * 3);
            h = QUOTE(safezoneH * 3);
            type = 0;
            size = 0;
            text = QPATHTOF(ui\pressurecuff\body_background_pressurecuff.paa);
        };
        class PressureCuffInteractables: BodyBackground {
            x = QUOTE(safezoneX);
            y = QUOTE(safezoneY + ((safezoneH * MEASUREBP_INTERACTABLE_SCALE) * 1.25));
            w = QUOTE(safezoneW * MEASUREBP_INTERACTABLE_SCALE);
            h = QUOTE(safezoneH * MEASUREBP_INTERACTABLE_SCALE);
            text = QPATHTOF(ui\pressurecuff\pressurecuff_interactables.paa);
        };

        class Stethoscope_Bell: RscPictureKeepAspect {
            idc = IDC_MEASUREBP_STETHOSCOPE;
            x = QUOTE(ACM_MEASUREBP_pxToScreen_X((MEASUREBP_INTERACTABLE_TOPLEFT_X + 1440)));
            y = QUOTE(ACM_MEASUREBP_pxToScreen_Y((MEASUREBP_INTERACTABLE_TOPLEFT_Y - 50)));
            w = QUOTE(ACM_pxToScreen_W(128));
            h = QUOTE(ACM_pxToScreen_H(128));
            text = QPATHTOEF(breathing,ui\stethoscope_bell.paa);
            show = 0;
        };

        class GaugeDial_1: RscLine {
            idc = IDC_MEASUREBP_DIAL_1;
            x = QUOTE(ACM_MEASUREBP_pxToScreen_X((MEASUREBP_INTERACTABLE_TOPLEFT_X + 634)));
            y = QUOTE(ACM_MEASUREBP_pxToScreen_Y((MEASUREBP_INTERACTABLE_TOPLEFT_Y + 247)));
            w = QUOTE(ACM_MEASUREBP_pxToScreen_W(0));
            h = QUOTE(ACM_MEASUREBP_pxToScreen_H(MEASUREBP_DIAL_LENGTH));
            colorText[] = {0,0,0,1};
        };
        class GaugeDial_2: GaugeDial_1 {
            idc = IDC_MEASUREBP_DIAL_2;
            y = QUOTE(ACM_MEASUREBP_pxToScreen_Y((MEASUREBP_INTERACTABLE_TOPLEFT_Y + 246)));
        };

        class HeartBack: RscPictureKeepAspect {
                idc = IDC_MEASUREBP_HEARTBACK;
                x = QUOTE(safezoneX + ((safezoneW / 2) - (safezoneW / 40)) + 0.03);
                y = QUOTE(safezoneY + ((safezoneH / 2) - (safezoneH / 40)) + 0.18);
                w = QUOTE(safezoneW / 20);
                h = QUOTE(safezoneH / 20);
                type = 0;
                size = 0;
                text = QPATHTOF(ui\feelpulse\heart_ca.paa);
                colorText[] = {1, 1, 1, 1};
                show = 0;
            };
            class Heart: HeartBack {
                idc = IDC_MEASUREBP_HEART;
                x = QUOTE(safezoneX + ((safezoneW / 2) - (safezoneW / 160)) + 0.03);
                y = QUOTE(safezoneY + ((safezoneH / 2) - (safezoneH / 160)) + 0.18);
                w = QUOTE(safezoneW / 80);
                h = QUOTE(safezoneH / 80);
                colorText[] = {1, 0, 0, 1};
            };
    };
    class Controls
    {
        class TopText: RscText {
            idc = -1;
            style = ST_CENTER;
            font = "RobotoCondensed";
            x = QUOTE(safezoneX);
            y = QUOTE(safezoneY * 3);
            w = QUOTE(safezoneW);
            h = QUOTE(safezoneH);
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            text = "Measuring Blood Pressure...";
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
            idc = IDC_MEASUREBP_TEXT;
            y = QUOTE(safezoneY * 2.85);
            text = "";
        };
        class Button_Bulb: RscButton {
            text = "";
            colorText[] = {1,1,1,0};
            colorDisabled[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            colorBackgroundDisabled[] = {1,1,1,0};
            colorBackgroundActive[] = {1,1,1,0};
            colorFocused[] = {1,1,1,0};
            colorBorder[] = {0,0,0,0};
            soundClick[] = {};
            soundEnter[] = {};
            soundPush[] = {};
            soundEscape[] = {};
            idc = IDC_MEASUREBP_BUTTON_BULB;
            style = 0;
            x = QUOTE(ACM_MEASUREBP_pxToScreen_X(MEASUREBP_INTERACTABLE_TOPLEFT_X));
            y = QUOTE(ACM_MEASUREBP_pxToScreen_Y((MEASUREBP_INTERACTABLE_TOPLEFT_Y + 85)));
            w = QUOTE(ACM_MEASUREBP_pxToScreen_W(267));
            h = QUOTE(ACM_MEASUREBP_pxToScreen_H(470));
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            onMouseButtonUp = QUOTE(call FUNC(MeasureBP_press));
            tooltip = "Squeeze Bulb\n+50 (LMB) | +30 (RMB)";
        };
        class Button_Valve: Button_Bulb {
            soundClick[] = {};
            idc = IDC_MEASUREBP_BUTTON_VALVE;
            x = QUOTE(ACM_MEASUREBP_pxToScreen_X((MEASUREBP_INTERACTABLE_TOPLEFT_X + 106)));
            y = QUOTE(ACM_MEASUREBP_pxToScreen_Y((MEASUREBP_INTERACTABLE_TOPLEFT_Y + 590)));
            w = QUOTE(ACM_MEASUREBP_pxToScreen_W(75));
            h = QUOTE(ACM_MEASUREBP_pxToScreen_H(75));
            tooltip = "Release Pressure\n-10 (LMB) | -2 (RMB)";
        };
    };
};