#include "MeasureBP_defines.hpp"

class GVAR(MeasureBP_Dialog)
{
    idd = IDC_MEASUREBP;
    movingEnable = 0;
    onLoad = "";
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(MeasureBP_DLG),nil)]);
    objects[] = {};
    class ControlsBackground {
        class BodyBackground: RscPicture {
            idc = -1;
            x = QUOTE(ACM_MEASUREBP_POS_X_CENTER(180,50));
            y = QUOTE(ACM_MEASUREBP_POS_Y_CENTER(135,36));
            w = QUOTE(ACM_MEASUREBP_POS_W(180));
            h = QUOTE(ACM_MEASUREBP_POS_H(135));
            type = 0;
            size = 0;
            text = QPATHTOF(ui\pressurecuff\body_background_pressurecuff.paa);
        };
        class PressureCuffInteractables: BodyBackground {
            x = QUOTE(ACM_MEASUREBP_POS_X(-12));
            y = QUOTE(ACM_MEASUREBP_POS_Y(12));
            w = QUOTE(ACM_MEASUREBP_POS_W(32));
            h = QUOTE(ACM_MEASUREBP_POS_H(24));
            text = QPATHTOF(ui\pressurecuff\pressurecuff_interactables.paa);
        };

        class Stethoscope_Bell: RscPicture {
            idc = IDC_MEASUREBP_STETHOSCOPE;
            x = QUOTE(ACM_MEASUREBP_POS_X_CENTER(4,29.5));
            y = QUOTE(ACM_MEASUREBP_POS_Y_CENTER(3,18));
            w = QUOTE(ACM_MEASUREBP_POS_W(4));
            h = QUOTE(ACM_MEASUREBP_POS_H(3));
            text = QPATHTOEF(breathing,ui\stethoscope_bell.paa);
            show = 0;
        };

        class GaugeDial: RscPicture {
            idc = IDC_MEASUREBP_DIAL;
            x = QUOTE(ACM_MEASUREBP_POS_X(2.65));
            y = QUOTE(ACM_MEASUREBP_POS_Y(13.12));
            w = QUOTE(ACM_MEASUREBP_POS_W(16));
            h = QUOTE(ACM_MEASUREBP_POS_H(12));
            text = QPATHTOEF(circulation,ui\pressurecuff\dial\dial_0.paa);
            colorText[] = {0,0,0,1};
        };

        class HeartBack: RscPicture {
            idc = IDC_MEASUREBP_HEARTBACK;
            x = QUOTE(ACM_MEASUREBP_POS_X_CENTER(4,29.5));
            y = QUOTE(ACM_MEASUREBP_POS_Y_CENTER(3,18));
            w = QUOTE(ACM_MEASUREBP_POS_W(4));
            h = QUOTE(ACM_MEASUREBP_POS_H(3));
            type = 0;
            size = 0;
            text = QPATHTOF(ui\feelpulse\heart_ca.paa);
            colorText[] = {1, 1, 1, 1};
            show = 0;
        };
        class Heart: HeartBack {
            idc = IDC_MEASUREBP_HEART;
            x = QUOTE(ACM_MEASUREBP_POS_X_CENTER(1,29.5));
            y = QUOTE(ACM_MEASUREBP_POS_Y_CENTER(0.75,18));
            w = QUOTE(ACM_MEASUREBP_POS_W(1));
            h = QUOTE(ACM_MEASUREBP_POS_H(0.75));
            colorText[] = {1, 0, 0, 1};
        };
    };
    class Controls
    {
        class TopText: RscText {
            idc = -1;
            style = ST_CENTER;
            font = "RobotoCondensed";
            x = QUOTE(safeZoneX);
            y = QUOTE(safeZoneY);
            w = QUOTE(safeZoneW);
            h = QUOTE(safeZoneH / 10);
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            text = CSTRING(MeasureBP_Measuring);
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
            idc = IDC_MEASUREBP_TEXT;
            h = QUOTE(safeZoneH / 6);
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
            x = QUOTE(ACM_MEASUREBP_POS_X(-11));
            y = QUOTE(ACM_MEASUREBP_POS_Y(14.8));
            w = QUOTE(ACM_MEASUREBP_POS_W(9.2));
            h = QUOTE(ACM_MEASUREBP_POS_H(13));
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            onMouseButtonUp = QUOTE(call FUNC(MeasureBP_press));
            tooltip = CSTRING(MeasureBP_Hint_Bulb);
        };
        class Button_Valve: Button_Bulb {
            soundClick[] = {};
            idc = IDC_MEASUREBP_BUTTON_VALVE;
            x = QUOTE(ACM_MEASUREBP_POS_X(-7.5));
            y = QUOTE(ACM_MEASUREBP_POS_Y(28));
            w = QUOTE(ACM_MEASUREBP_POS_W(2.8));
            h = QUOTE(ACM_MEASUREBP_POS_H(2.2));
            tooltip = CSTRING(MeasureBP_Hint_Valve);
        };
    };
};