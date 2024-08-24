#include "TreatmentText_defines.hpp"

class RscPicture;
class RscPictureKeepAspect;
class RscText;

class RscTitles
{
    class RscTreatmentText
    {
        idd = IDC_TREATMENTTEXT;
        fadein = 0;
        fadeout = 0;
        duration = 1e+011;
        onLoad = QUOTE(uiNamespace setVariable [ARR_2('ACM_TreatmentText',(_this select 0))];);
        onUnLoad = QUOTE(uiNamespace setVariable [ARR_2('ACM_TreatmentText',nil)];);
        class Controls
        {
            class Text: RscText {
                idc = IDC_TREATMENTTEXT_TEXT;
                style = ST_CENTER;
                font = "RobotoCondensed";
                x = QUOTE(safezoneX);
                y = QUOTE(safezoneY);
                w = QUOTE(safezoneW);
                h = QUOTE(safezoneH * 1.5);
                colorText[] = {1,1,1,1};
                colorBackground[] = {0,0,0,0};
                text = "";
                lineSpacing = 0;
                sizeEx = QUOTE(GUI_GRID_H * 1 * NORMALIZE_SIZEEX);
                fixedWidth = 0;
                deletable = 0;
                fade = 0;
                access = 0;
                type = 0;
                shadow = 1;
                colorShadow[] = {0,0,0,0.5};
            };
        };
    };
};
