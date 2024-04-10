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
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(AEDMonitor_DLG),nil)]);
    objects[] = {};

    class ControlsBackground {
        class VitalsSectionBackground: RscText {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X(330));
            y = QUOTE(AMS_pxToScreen_Y(900));
            w = QUOTE(AMS_pxToScreen_W(170));
            h = QUOTE(AMS_pxToScreen_H(550));
            colorBackground[] = {0.18,0.26,0.29,1};
            text = "";
        };
        class HRVitalsBackground: RscText {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X(330));
            y = QUOTE(AMS_pxToScreen_Y(VitalsBG_Spacing_Y(0)));
            w = QUOTE(AMS_pxToScreen_W(170));
            h = QUOTE(AMS_pxToScreen_H(150));
            colorBackground[] = {0,0,0,1};
        };
        class SpO2VitalsBackground: HRVitalsBackground {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsBG_Spacing_Y(1)));
        };
        class CO2VitalsBackground: HRVitalsBackground {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsBG_Spacing_Y(2)));
        };
        class BPVitalsBackground: HRVitalsBackground {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsBG_Spacing_Y(3)));
        };
        class VitalsWaveformBackground: RscText {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X(500));
            y = QUOTE(AMS_pxToScreen_Y(900));
            w = QUOTE(AMS_pxToScreen_W(700));
            h = QUOTE(AMS_pxToScreen_H(310));
            type = 0;
            style = 80;
            colorBackground[] = {0,0,0,1};
            colorText[] = {0,0,0,0};
            text = "";
        };
        class TopBarBackground: VitalsSectionBackground {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(880));
            w = QUOTE(AMS_pxToScreen_W(870));
            h = QUOTE(AMS_pxToScreen_H(20));
        };
        class VitalsSectionDividerBackground: VitalsSectionBackground {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X(499));
            w = QUOTE(AMS_pxToScreen_W(2));
            h = QUOTE(AMS_pxToScreen_H(660));
        };

        class HRVitalsHeader: RscText {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X(320));
            y = QUOTE(AMS_pxToScreen_Y(VitalsHeader_Spacing_Y(0)));
            w = QUOTE(AMS_pxToScreen_W(50));
            h = QUOTE(AMS_pxToScreen_H(25));
            colorBackground[] = {0,0,0,0};
            colorText[] = HR_COLOR;
            font = "RobotoCondensed";
            shadow = 0;
            type = 0;
            style = 0;
            sizeEx = QUOTE(AMS_GRID_H * 0.4 * (0.55 / (getResolution select 5)));
            text = "HR";
        };
        class SpO2VitalsHeader: HRVitalsHeader {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsHeader_Spacing_Y(1)));
            colorText[] = SPO2_COLOR;
            text = "SpO2";
        };
        class CO2VitalsHeader: HRVitalsHeader {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsHeader_Spacing_Y(2)));
            colorText[] = CO2_COLOR;
            text = "CO2";
        };
        class BPVitalsHeader: HRVitalsHeader {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsHeader_Spacing_Y(3)));
            colorText[] = NIBP_COLOR;
            text = "NIBP";
        };

        class HRVitalsDisplay: RscText {
            idc = IDC_VITALSDISPLAY_HR;
            x = QUOTE(AMS_pxToScreen_X(385));
            y = QUOTE(AMS_pxToScreen_Y(VitalsDisplay_Spacing_Y(0)));
            w = QUOTE(AMS_pxToScreen_W(120));
            h = QUOTE(AMS_pxToScreen_H(90));
            colorBackground[] = {0,0,0,0};
            colorText[] = HR_COLOR;
            font = "RobotoCondensedBold";
            shadow = 0;
            type = 0;
            style = 1;
            sizeEx = QUOTE(AMS_GRID_H * 1.9 * (0.55 / (getResolution select 5)));
            text = "0";
        };
        class SpO2VitalsDisplay: HRVitalsDisplay {
            idc = IDC_VITALSDISPLAY_SPO2;
            x = QUOTE(AMS_pxToScreen_X(390));
            y = QUOTE(AMS_pxToScreen_Y(VitalsDisplay_Spacing_Y(1)));
            w = QUOTE(AMS_pxToScreen_W(115));
            h = QUOTE(AMS_pxToScreen_H(93));
            colorText[] = SPO2_COLOR;
            font = "RobotoCondensedBold";
            sizeEx = QUOTE(AMS_GRID_H * 1.7 * (0.55 / (getResolution select 5)));
            text = "0";
        };

        class EKG_Line_0: RscLine {
            idc = IDC_EKG_LINE_0;
            x = QUOTE(AMS_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(AMS_pxToScreen_Y(EKG_Line_Y(0)));
            w = QUOTE(AMS_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(AMS_pxToScreen_H(0));
            colorBackground[] = {0,0,0,0};
            colorText[] = HR_COLOR;
            text = "";
        };
        EKG_LINES
        class EKG_Dot_0: RscText {
            idc = IDC_EKG_DOT_0;
            x = QUOTE(AMS_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(AMS_pxToScreen_Y(EKG_Line_Y(0)));
            w = QUOTE(AMS_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(AMS_pxToScreen_H(2));
            colorBackground[] = HR_COLOR;
            text = "";
        };
        EKG_DOTS
        class PO_Line_0: RscLine {
            idc = IDC_PO_LINE_0;
            x = QUOTE(AMS_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(AMS_pxToScreen_Y(EKG_Line_Y(160)));
            w = QUOTE(AMS_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(AMS_pxToScreen_H(0));
            colorBackground[] = {0,0,0,0};
            colorText[] = SPO2_COLOR;
            text = "";
        };
        PO_LINES
        class PO_Dot_0: RscText {
            idc = IDC_PO_DOT_0;
            x = QUOTE(AMS_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(AMS_pxToScreen_Y(EKG_Line_Y(160)));
            w = QUOTE(AMS_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(AMS_pxToScreen_H(2));
            colorBackground[] = SPO2_COLOR;
            text = "";
        };
        PO_DOTS
    };

    class Controls {};
};
