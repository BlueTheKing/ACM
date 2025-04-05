#include "FeelPulse_defines.hpp"

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
                x = QUOTE(safeZoneX);
                y = QUOTE(safeZoneY);
                w = QUOTE(safeZoneW);
                h = QUOTE(safeZoneH / 10);
                colorText[] = {1,1,1,1};
                colorBackground[] = {0,0,0,0};
                text = CSTRING(FeelPulse_FeelingForPulse);
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
                idc = IDC_FEELPULSE_TEXT;
                h = QUOTE(safeZoneH / 6);
                text = "";
            };
            class HeartBack: RscPicture {
                idc = -1;
                x = QUOTE(ACM_FEELPULSE_POS_X_CENTER(4));
                y = QUOTE(ACM_FEELPULSE_POS_Y_CENTER(3));
                w = QUOTE(ACM_FEELPULSE_POS_W(4));
                h = QUOTE(ACM_FEELPULSE_POS_H(3));
                type = 0;
                size = 0;
                text = QPATHTOF(ui\feelpulse\heart_ca.paa);
                colorText[] = {1, 1, 1, 1};
            };
            class Heart: HeartBack {
                idc = IDC_FEELPULSE_HEART;
                x = QUOTE(ACM_FEELPULSE_POS_X_CENTER(ACM_FEELPULSE_FRONT_W));
                y = QUOTE(ACM_FEELPULSE_POS_Y_CENTER(ACM_FEELPULSE_FRONT_H));
                w = QUOTE(ACM_FEELPULSE_POS_W(ACM_FEELPULSE_FRONT_W));
                h = QUOTE(ACM_FEELPULSE_POS_H(ACM_FEELPULSE_FRONT_H));
                colorText[] = {1, 0, 0, 1};
            };
        };
    };
};
