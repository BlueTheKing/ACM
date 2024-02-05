#include "defines.hpp"

class RscPicture;
class RscLine;
class RscText;
class RscBackground;
class RscButton;
class RscStructuredText;

class GVAR(Lifepak_Monitor_Dialog) {
    idd = IDC_LIFEPAK_MONITOR;
    movingEnable = 0;
    onLoad = "";
    onUnload = "";
    objects[] = {};

    class ControlsBackground {
        class BlackBackground: RscText {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X(500));
            y = QUOTE(AMS_pxToScreen_Y(900));
            w = QUOTE(AMS_pxToScreen_W(700));
            h = QUOTE(AMS_pxToScreen_H(150));
            type = 0;
            style = 80;
            colorBackground[] = {0,0,0,1};
            colorText[] = {0,0,0,1};
            text = "";
        };
        class EKG_Line_0: RscLine {
            idc = IDC_EKG_LINE_0;
            x = QUOTE(AMS_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(AMS_pxToScreen_Y(EKG_Line_Y(0)));
            w = QUOTE(AMS_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(AMS_pxToScreen_H(0));
            //style = 192;
            colorBackground[] = {0,0,0,0};
            colorText[] = {0,1,0,1};
            text = "";
        };
        EKG_LINES
    };

    class Controls {};
};
