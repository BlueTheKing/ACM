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
        class Black_Background: RscText {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X - 20)));
            y = QUOTE(AMS_pxToScreen_Y((AED_TOPLEFT_Y - 20)));
            w = QUOTE(AMS_pxToScreen_W(1000));
            h = QUOTE(AMS_pxToScreen_H(700));
            colorBackground[] = {0,0,0,1};
        };
        class Black_Background2: Black_Background {};
        class VitalsSection_Background: RscText {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X - 10))); // 330
            y = QUOTE(AMS_pxToScreen_Y(AED_TOPLEFT_Y)); // 900
            w = QUOTE(AMS_pxToScreen_W(180));
            h = QUOTE(AMS_pxToScreen_H(550));
            colorBackground[] = {0.18,0.26,0.29,1};
            text = "";
        };
        class HR_Vitals_Background: RscText {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X - 10))); // 330
            y = QUOTE(AMS_pxToScreen_Y(VitalsBG_Spacing_Y(0)));
            w = QUOTE(AMS_pxToScreen_W(180));
            h = QUOTE(AMS_pxToScreen_H(140));
            colorBackground[] = {0,0,0,1};
        };
        class SpO2_Vitals_Background: HR_Vitals_Background {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsBG_Spacing_Y(1)));
        };
        class CO2_Vitals_Background: HR_Vitals_Background {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsBG_Spacing_Y(2)));
        };
        class BP_Vitals_Background: HR_Vitals_Background {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsBG_Spacing_Y(3)));
        };
        class Top_Bar_Background: VitalsSection_Background {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(AED_TOPLEFT_Y)); // 880
            w = QUOTE(AMS_pxToScreen_W(900));
            h = QUOTE(AMS_pxToScreen_H(20));
        };
        class Vitals_SectionDivider_Background: VitalsSection_Background {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X + 169)));
            w = QUOTE(AMS_pxToScreen_W(2));
            h = QUOTE(AMS_pxToScreen_H(660));
        };

        class HR_Vitals_Header: RscText {
            idc = -1;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X - 10)));
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
        class SpO2_Vitals_Header: HR_Vitals_Header {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsHeader_Spacing_Y(1)));
            colorText[] = SPO2_COLOR;
            text = "SpO2";
        };
        class CO2_Vitals_Header: HR_Vitals_Header {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsHeader_Spacing_Y(2)));
            colorText[] = CO2_COLOR;
            text = "CO2";
        };
        class BP_Vitals_Header: HR_Vitals_Header {
            idc = -1;
            y = QUOTE(AMS_pxToScreen_Y(VitalsHeader_Spacing_Y(3)));
            colorText[] = NIBP_COLOR;
            text = "NIBP";
        };

        class HR_Vitals_Display: RscText {
            idc = IDC_VITALSDISPLAY_HR;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X + 50))); // 380
            y = QUOTE(AMS_pxToScreen_Y(VitalsDisplay_Spacing_Y(0)));
            w = QUOTE(AMS_pxToScreen_W(125));
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
        class SpO2_Vitals_Display: HR_Vitals_Display {
            idc = IDC_VITALSDISPLAY_SPO2;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X + 60))); // 390
            y = QUOTE(AMS_pxToScreen_Y(VitalsDisplay_Spacing_Y(1)));
            w = QUOTE(AMS_pxToScreen_W(115));
            h = QUOTE(AMS_pxToScreen_H(93));
            colorText[] = SPO2_COLOR;
            font = "RobotoCondensedBold";
            sizeEx = QUOTE(AMS_GRID_H * 1.7 * (0.55 / (getResolution select 5)));
            text = "0";
        };
        class CO2_Vitals_Display: SpO2_Vitals_Display {
            idc = IDC_VITALSDISPLAY_CO2;
            y = QUOTE(AMS_pxToScreen_Y(VitalsDisplay_Spacing_Y(2)));
            w = QUOTE(AMS_pxToScreen_W(115));
            h = QUOTE(AMS_pxToScreen_H(93));
            colorText[] = CO2_COLOR;
            text = "0";
        };
        class RR_Vitals_Display: CO2_Vitals_Display {
            idc = IDC_VITALSDISPLAY_RR;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X - 38)));
            y = QUOTE(AMS_pxToScreen_Y((VitalsDisplay_Spacing_Y(2) + 12)));
            w = QUOTE(AMS_pxToScreen_W(80));
            h = QUOTE(AMS_pxToScreen_H(80));
            sizeEx = QUOTE(AMS_GRID_H * 0.8 * (0.55 / (getResolution select 5)));
            text = "0";
        };
        class RR_Text_Vitals_Display: RR_Vitals_Display {
            idc = IDC_VITALSDISPLAY_RR_TEXT;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X - 14)));
            y = QUOTE(AMS_pxToScreen_Y((VitalsDisplay_Spacing_Y(2) + 9)));
            sizeEx = QUOTE(AMS_GRID_H * 0.45 * (0.55 / (getResolution select 5)));
            text = "RR";
        };
        class NIBP_S_Vitals_Display: SpO2_Vitals_Display {
            idc = IDC_VITALSDISPLAY_NIBP_S;
            y = QUOTE(AMS_pxToScreen_Y(VitalsDisplay_Spacing_Y(3)));
            w = QUOTE(AMS_pxToScreen_W(115));
            h = QUOTE(AMS_pxToScreen_H(93));
            colorText[] = NIBP_COLOR;
            text = "0";
        };
        class NIBP_D_Vitals_Display: SpO2_Vitals_Display {
            idc = IDC_VITALSDISPLAY_NIBP_D;
            y = QUOTE(AMS_pxToScreen_Y((VitalsDisplay_Spacing_Y(3) + 55)));
            colorText[] = NIBP_COLOR;
            text = "0";
        };
        class NIBP_Mean_Vitals_Display: NIBP_D_Vitals_Display {
            idc = IDC_VITALSDISPLAY_NIBPMEAN;
            x = QUOTE(AMS_pxToScreen_X((AED_TOPLEFT_X - 48)));
            y = QUOTE(AMS_pxToScreen_Y((VitalsDisplay_Spacing_Y(3) + 68)));
            w = QUOTE(AMS_pxToScreen_W(100));
            h = QUOTE(AMS_pxToScreen_H(90));
            sizeEx = QUOTE(AMS_GRID_H * 0.8 * (0.55 / (getResolution select 5)));
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
        class AEDBackground: RscPicture {
            idc = -1;
            x = QUOTE(AMS_GUI_GRID_X);
            y = QUOTE(AMS_GUI_GRID_Y);
            w = QUOTE(AMS_GUI_GRID_W * AMS_GUI_SIZEM);
            h = QUOTE(AMS_GUI_GRID_H * AMS_GUI_SIZEM);
            type = 0;
            style = 48;
            size = 0;
            text = QPATHTOF(ui\lifepak\background_ca.paa);
        };
    };

    class Controls {};
};
