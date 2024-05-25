#include "Stethoscope_defines.hpp"

class RscPicture;
class RscLine;
class RscText;
class RscBackground;
class RscButtonMenu;
class RscPictureKeepAspect;

class GVAR(Stethoscope_Dialog) {
    idd = IDC_STETHOSCOPE;
    movingEnable = 0;
    onLoad = "";
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(Stethoscope_DLG),nil)]);
    objects[] = {};

    class ControlsBackground {
        class BodyBackground: RscPictureKeepAspect {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW * 1.5));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH));
            w = QUOTE(safezoneW * 3);
            h = QUOTE(safezoneH * 3);
            type = 0;
            size = 0;
            text = QPATHTOF(ui\body_background.paa);
        };

        class RightLungSpace: RscText {
            idc = IDC_STETHOSCOPE_RIGHTLUNG;
            x = QUOTE(ACM_pxToScreen_X(STETHOSCOPE_TOPLEFT_X));
            y = QUOTE(ACM_pxToScreen_Y(STETHOSCOPE_TOPLEFT_Y));
            w = QUOTE(ACM_pxToScreen_W(STETHOSCOPE_LUNG_WIDTH));
            h = QUOTE(ACM_pxToScreen_H(STETHOSCOPE_LUNG_HEIGHT));
            colorBackground[] = {1,1,1,0.5};
            show = 0;
        };

        class LeftLungSpace: RightLungSpace {
            idc = IDC_STETHOSCOPE_LEFTLUNG;
            x = QUOTE(ACM_pxToScreen_X((STETHOSCOPE_TOPLEFT_X + 445)));
        };
        class HeartSpace: RightLungSpace {
            idc = IDC_STETHOSCOPE_HEART;
            x = QUOTE(ACM_pxToScreen_X((STETHOSCOPE_TOPLEFT_X + 320)));
            y = QUOTE(ACM_pxToScreen_Y((STETHOSCOPE_TOPLEFT_Y + 80)));
            w = QUOTE(ACM_pxToScreen_W(STETHOSCOPE_HEART_WIDTH));
            h = QUOTE(ACM_pxToScreen_H(STETHOSCOPE_HEART_HEIGHT));
            colorBackground[] = {1,0,0,0.5};
        };
        class ClavicleSpace: RightLungSpace {
            idc = IDC_STETHOSCOPE_CLAVICLE;
            x = QUOTE(ACM_pxToScreen_X((STETHOSCOPE_TOPLEFT_X - 40)));
            y = QUOTE(ACM_pxToScreen_Y((STETHOSCOPE_TOPLEFT_Y - 80)));
            w = QUOTE(ACM_pxToScreen_W(915));
            h = QUOTE(ACM_pxToScreen_H(60));
            colorBackground[] = {0,1,0,0.1};
        };
    };
    class Controls {
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
            text = "Using Stethoscope...";
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
            idc = IDC_STETHOSCOPE_TEXT;
            y = QUOTE(safezoneY * 2.85);
            text = "";
        };

        class Bell: RscButtonMenu {
            idc = IDC_STETHOSCOPE_BELL;
            soundClick[] = {};
            soundEnter[] = {};
            soundPush[] = {};
            soundEscape[] = {};
            x = QUOTE(ACM_pxToScreen_X(960));
            y = QUOTE(ACM_pxToScreen_Y(800));
            w = QUOTE(ACM_pxToScreen_W(128));
            h = QUOTE(ACM_pxToScreen_H(128));
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            onMouseButtonUp = QUOTE(call FUNC(Stethoscope_MoveBell));
            textureNoShortcut = QPATHTOF(ui\stethoscope_bell.paa);
            tooltip = "Move me";
            colorBackground[] = {1,1,1,0};
            colorBackgroundFocused[] = {1,1,1,0};
            period = 0;
            periodFocus = 0;
            periodOver = 0;
            class ShortcutPos
            {
                left = 0;
                top = 0;
                w = QUOTE(ACM_pxToScreen_W(128));
                h = QUOTE(ACM_pxToScreen_H(128));
            };
        };
    };
};
