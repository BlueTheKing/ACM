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
                x = QUOTE(safeZoneX);
                y = QUOTE(safeZoneY);
                w = QUOTE(safeZoneW);
                h = QUOTE(safeZoneH / 10);
                colorText[] = {1,1,1,1};
                colorBackground[] = {0,0,0,0};
                text = CSTRING(HeadTiltChinLift_ActionInProgress);
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
                idc = IDC_HEADTILT_TEXT;
                h = QUOTE(safeZoneH / 6);
                text = "";
            };
        };
    };
};
