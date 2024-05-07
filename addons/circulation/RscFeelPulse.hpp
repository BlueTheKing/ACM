#include "FeelPulse_defines.hpp"

class RscPicture;
class RscPictureKeepAspect;
class RscText;

class RscTitles
{
    class RscFeelPulse
    {
        idd = IDC_FEELPULSE;
        fadein = 0;
        fadeout = 0;
        duration = 1e+011;
        onLoad = QUOTE(uiNamespace setVariable [ARR_2('ACM_FeelPulse',(_this select 0))];);
        onUnLoad = QUOTE(uiNamespace setVariable [ARR_2('ACM_FeelPulse',nil)];);
        class Controls
        {
            class TopText: RscText {
                idc = -1;
                style = ST_CENTER;
                font = "RobotoCondensed";
                x = QUOTE(safezoneX);
                y = QUOTE(safezoneY * 2);
                w = QUOTE(safezoneW);
                h = QUOTE(safezoneH);
                colorText[] = {1,1,1,1};
                colorBackground[] = {0,0,0,0};
                text = "Feeling for pulse...";
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
                idc = IDC_FEELPULSE_TEXT;
                y = QUOTE(safezoneY * 1.85);
                text = "";
            };
            class HeartBack: RscPictureKeepAspect {
                idc = -1;
                x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 40));
                y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 40));
                w = QUOTE(safezoneW / 20);
                h = QUOTE(safezoneH / 20);
                type = 0;
                size = 0;
                text = QPATHTOF(ui\feelpulse\heart_ca.paa);
                colorText[] = {1, 1, 1, 1};
            };
            class Heart: HeartBack {
                idc = IDC_FEELPULSE_HEART;
                x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 160));
                y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 160));
                w = QUOTE(safezoneW / 80);
                h = QUOTE(safezoneH / 80);
                colorText[] = {1, 0, 0, 1};
            };
        };
    };
};
