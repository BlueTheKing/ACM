#include "\a3\ui_f\hpp\defineCommonGrids.inc"
#include "TreatmentText_defines.hpp"

class RscText;
class RscStructuredText;

class RscTitles {
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
    class ACEGVAR(dogtags,singleTag) {
        class controls {
            class nickname: RscStructuredText {
                y = QUOTE(0.052 * safeZoneH + (profileNamespace getVariable [ARR_2('TRIPLES(IGUI,ACEGVAR(dogtags,grid),Y)',safeZoneY + 0.175 * safeZoneH)]));
                h = QUOTE(3.2 * GUI_GRID_H);
                /*class Attributes {
                    font = "RobotoCondensed";
                    color = "#EEEEEE"; //color = "#636363";
                    align = "left";
                    valign = "middle";
                    shadow = 2; //shadow = 0;
                    shadowColor = "#3f4345"; //shadowColor = "#636363";
                    size = "0.80";
                };*/
            };
        };
    };
    class ACEGVAR(dogtags,doubleTag): ACEGVAR(dogtags,singleTag) {
        class controls: controls {
            class nickname: nickname {
                y = QUOTE(0.052 * safeZoneH + (profileNamespace getVariable [ARR_2('TRIPLES(IGUI,ACEGVAR(dogtags,grid),Y)',safeZoneY + 0.175 * safeZoneH)]));
                h = QUOTE(3.2 * GUI_GRID_H);
            };
        };
    };
};
