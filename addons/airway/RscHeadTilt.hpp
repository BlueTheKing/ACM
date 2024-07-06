#include "HeadTilt_defines.hpp"

class RscText;

class RscTitles
{
    class RscHeadTilt
    {
        idd = IDC_HEADTILT;
        fadein = 0;
        fadeout = 0;
        duration = 1e+011;
        onLoad = QUOTE(uiNamespace setVariable [ARR_2('ACM_HeadTilt',(_this select 0))];);
        onUnLoad = QUOTE(uiNamespace setVariable [ARR_2('ACM_HeadTilt',nil)];);
        class Controls
        {
            class TopText: RscText {
                idc = IDC_HEADTILT_TOPTEXT;
                style = ST_CENTER;
                font = "RobotoCondensed";
                x = QUOTE(safezoneX);
                y = QUOTE(safezoneY * 2);
                w = QUOTE(safezoneW);
                h = QUOTE(safezoneH);
                colorText[] = {1,1,1,1};
                colorBackground[] = {0,0,0,0};
                text = "Performing Head Tilt-Chin Lift...";
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
                idc = IDC_HEADTILT_TEXT;
                y = QUOTE(safezoneY * 1.85);
                text = "";
            };
        };
    };
};
