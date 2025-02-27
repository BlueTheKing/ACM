#include "\a3\ui_f\hpp\defineCommonGrids.inc"
#include "TreatmentText_defines.hpp"
#include "ContinuousActionText_defines.hpp"

class RscText;
class RscPicture;
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
    class RscContinuousActionText
    {
        idd = IDC_CONTINUOUSACTIONTEXT;
        fadein = 0;
        fadeout = 0;
        duration = 1e+011;
        onLoad = QUOTE(uiNamespace setVariable [ARR_2('ACM_ContinuousActionText',(_this select 0))];);
        onUnLoad = QUOTE(uiNamespace setVariable [ARR_2('ACM_ContinuousActionText',nil)];);
        class Controls
        {
            class TopText: RscText {
                idc = IDC_CONTINUOUSACTIONTEXT_UPPER;
                style = ST_CENTER;
                font = "RobotoCondensed";
                x = QUOTE(safezoneX);
                y = QUOTE(safezoneY);
                w = QUOTE(safezoneW);
                h = QUOTE(safezoneH / 10);
                colorText[] = {1,1,1,1};
                colorBackground[] = {0,0,0,0};
                text = "";
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
                idc = IDC_CONTINUOUSACTIONTEXT_BOTTOM;
                h = QUOTE(safezoneH / 6);
                text = "";
            };
        };
    };
    class GVAR(singleTag) {
        idd = -1;
        onLoad = QUOTE(uiNamespace setVariable [ARR_2(QQACEGVAR(dogtags,tag),_this select 0)]);
        onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQACEGVAR(dogtags,tag),nil)]);
        fadeIn = 0.2;
        fadeOut = 0.2;
        duration = 5;
        movingEnable = 0;
        class controls {
            class background: RscPicture {
                idc = 1000;
                x = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,ACEGVAR(dogtags,grid),X)',(safeZoneX + safeZoneW) - 12.9 * GUI_GRID_W)]);
                y = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,ACEGVAR(dogtags,grid),Y)',safeZoneY + 0.175 * safeZoneH)]);
                w = QUOTE(8 * GUI_GRID_W);
                h = QUOTE(8 * GUI_GRID_H);
                text = QACEPATHTOF(dogtags,data\dogtagSingle.paa);
                colorText[] = {1, 1, 1, 1};
            };
            class nickname: RscStructuredText {
                idc = 1001;
                text = "";
                sizeEx = QUOTE(GUI_GRID_H);
                colorText[] = {1, 1, 1, 1};
                colorBackground[] = {0, 0, 0, 0};
                x = QUOTE(1.4 * GUI_GRID_W + (profileNamespace getVariable [ARR_2('TRIPLES(IGUI,ACEGVAR(dogtags,grid),X)',(safeZoneX + safeZoneW) - 12.9 * GUI_GRID_W)]));
                y = QUOTE(0.052 * safeZoneH + ((profileNamespace getVariable [ARR_2('TRIPLES(IGUI,ACEGVAR(dogtags,grid),Y)',(safeZoneY + 0.175 * safeZoneH))]) / NORMALIZE_UISCALE));
                w = QUOTE(5.9 * GUI_GRID_W);
                h = QUOTE(3.2 * GUI_GRID_H);
                font = "RobotoCondensed";
                class Attributes {
                    font = "RobotoCondensed";
                    color = "#FFFFFF";
                    align = "left";
                    valign = "middle";
                    shadow = 2;
                    shadowColor = "#3f4345";
                    size = QUOTE(0.7 * NORMALIZE_SIZEEX);
                };
            };
        };
    };
    class GVAR(doubleTag): GVAR(singleTag) {
        class controls: controls {
            class background: background {
                text = QACEPATHTOF(dogtags,data\dogtagDouble.paa);
            };
            class nickname: nickname {
                class Attributes: Attributes {
                    font = "RobotoCondensed";
                    color = "#FFFFFF";
                    align = "left";
                    valign = "middle";
                    shadow = 2;
                    shadowColor = "#3f4345";
                    size = QUOTE(0.7 * NORMALIZE_SIZEEX);
                };
            };
        };
    };
};
