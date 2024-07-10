#include "TransfusionMenu_defines.hpp"

class RscPicture;
class RscLine;
class RscText;
class RscBackground;
class RscButtonMenu;
class RscPictureKeepAspect;
class RscControlsGroupNoScrollbars;

class GVAR(TransfusionMenu_Dialog) {
    idd = IDC_TRANSFUSIONMENU;
    movingEnable = 0;
    onLoad = "";
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(TransfusionMenu_DLG),nil)]);
    objects[] = {};

    class ControlsBackground {
        class MenuBackground: RscText {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 4));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 4));
            w = QUOTE(safezoneW / 2);
            h = QUOTE(safezoneH / 2);
            colorBackground[] = {0,0,0,0.7};
        };
        /*class MenuBackground: RscControlsGroupNoScrollbars {
            idc = IDC_TRANSFUSIONMENU;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 4));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 4));
            w = QUOTE(safezoneW / 2);
            h = QUOTE(safezoneH / 2);
            colorBackground[] = {0,0,0,0.7};
        };*/
        /*class BodyBackground: RscPictureKeepAspect {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW * 1.5));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH));
            w = QUOTE(safezoneW * 3);
            h = QUOTE(safezoneH * 3);
            type = 0;
            size = 0;
            text = QPATHTOEF(gui,ui\body_background.paa);
        };*/
    };
    class Controls {
    };
};
