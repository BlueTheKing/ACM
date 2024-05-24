#include "Defibrillator_defines.hpp"

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
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X - 20)));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_TOPLEFT_Y - 20)));
            w = QUOTE(ACM_AED_pxToScreen_W(1000));
            h = QUOTE(ACM_AED_pxToScreen_H(700));
            colorBackground[] = {0,0,0,1};
        };
        class Black_Background2: Black_Background {};
        class VitalsSection_Background: RscText {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X - 10))); // 330
            y = QUOTE(ACM_AED_pxToScreen_Y(AED_TOPLEFT_Y)); // 900
            w = QUOTE(ACM_AED_pxToScreen_W(180));
            h = QUOTE(ACM_AED_pxToScreen_H(550));
            colorBackground[] = {0.18,0.26,0.29,1};
            text = "";
        };
        class HR_Vitals_Background: RscText {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X - 10))); // 330
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsBG_Spacing_Y(0)));
            w = QUOTE(ACM_AED_pxToScreen_W(180));
            h = QUOTE(ACM_AED_pxToScreen_H(140));
            colorBackground[] = {0,0,0,1};
        };
        class SpO2_Vitals_Background: HR_Vitals_Background {
            idc = -1;
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsBG_Spacing_Y(1)));
        };
        class CO2_Vitals_Background: HR_Vitals_Background {
            idc = -1;
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsBG_Spacing_Y(2)));
        };
        class BP_Vitals_Background: HR_Vitals_Background {
            idc = -1;
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsBG_Spacing_Y(3)));
        };
        class Top_Bar_Background: VitalsSection_Background {
            idc = -1;
            y = QUOTE(ACM_AED_pxToScreen_Y(AED_TOPLEFT_Y)); // 880
            w = QUOTE(ACM_AED_pxToScreen_W(900));
            h = QUOTE(ACM_AED_pxToScreen_H(20));
        };
        class Vitals_SectionDivider_Background: VitalsSection_Background {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X + 169)));
            w = QUOTE(ACM_AED_pxToScreen_W(2));
            h = QUOTE(ACM_AED_pxToScreen_H(660));
        };

        class HR_Vitals_Header: RscText {
            idc = IDC_VITALSDISPLAY_HR_TEXT;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X - 10)));
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsHeader_Spacing_Y(0)));
            w = QUOTE(ACM_AED_pxToScreen_W(80));
            h = QUOTE(ACM_AED_pxToScreen_H(25));
            colorBackground[] = {0,0,0,0};
            colorText[] = HR_COLOR;
            font = "RobotoCondensed";
            shadow = 0;
            type = 0;
            style = 0;
            sizeEx = QUOTE(ACM_GRID_H * 0.4 * (0.55 / (getResolution select 5)));
            text = "HR";
        };
        class SpO2_Vitals_Header: HR_Vitals_Header {
            idc = -1;
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsHeader_Spacing_Y(1)));
            colorText[] = SPO2_COLOR;
            text = "SpO2";
        };
        class CO2_Vitals_Header: HR_Vitals_Header {
            idc = -1;
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsHeader_Spacing_Y(2)));
            colorText[] = CO2_COLOR;
            text = "CO2";
        };
        class BP_Vitals_Header: HR_Vitals_Header {
            idc = -1;
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsHeader_Spacing_Y(3)));
            colorText[] = NIBP_COLOR;
            text = "NIBP";
        };

        class HR_Vitals_Display: RscText {
            idc = IDC_VITALSDISPLAY_HR;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X + 50))); // 380
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsDisplay_Spacing_Y(0)));
            w = QUOTE(ACM_AED_pxToScreen_W(125));
            h = QUOTE(ACM_AED_pxToScreen_H(90));
            colorBackground[] = {0,0,0,0};
            colorText[] = HR_COLOR;
            font = "RobotoCondensedBold";
            shadow = 0;
            type = 0;
            style = 1;
            sizeEx = QUOTE(ACM_GRID_H * 1.9 * (0.55 / (getResolution select 5)));
            text = "0";
        };
        class SpO2_Vitals_Display: HR_Vitals_Display {
            idc = IDC_VITALSDISPLAY_SPO2;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X + 60))); // 390
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsDisplay_Spacing_Y(1)));
            w = QUOTE(ACM_AED_pxToScreen_W(115));
            h = QUOTE(ACM_AED_pxToScreen_H(93));
            colorText[] = SPO2_COLOR;
            font = "RobotoCondensedBold";
            sizeEx = QUOTE(ACM_GRID_H * 1.7 * (0.55 / (getResolution select 5)));
            text = "0";
        };
        class CO2_Vitals_Display: SpO2_Vitals_Display {
            idc = IDC_VITALSDISPLAY_CO2;
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsDisplay_Spacing_Y(2)));
            w = QUOTE(ACM_AED_pxToScreen_W(115));
            h = QUOTE(ACM_AED_pxToScreen_H(93));
            colorText[] = CO2_COLOR;
            text = "0";
        };
        class RR_Vitals_Display: CO2_Vitals_Display {
            idc = IDC_VITALSDISPLAY_RR;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X - 38)));
            y = QUOTE(ACM_AED_pxToScreen_Y((VitalsDisplay_Spacing_Y(2) + 12)));
            w = QUOTE(ACM_AED_pxToScreen_W(80));
            h = QUOTE(ACM_AED_pxToScreen_H(80));
            sizeEx = QUOTE(ACM_GRID_H * 0.8 * (0.55 / (getResolution select 5)));
            text = "0";
        };
        class RR_Text_Vitals_Display: RR_Vitals_Display {
            idc = IDC_VITALSDISPLAY_RR_TEXT;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X - 14)));
            y = QUOTE(ACM_AED_pxToScreen_Y((VitalsDisplay_Spacing_Y(2) + 9)));
            sizeEx = QUOTE(ACM_GRID_H * 0.45 * (0.55 / (getResolution select 5)));
            text = "RR";
        };
        class NIBP_S_Vitals_Display: SpO2_Vitals_Display {
            idc = IDC_VITALSDISPLAY_NIBP_S;
            y = QUOTE(ACM_AED_pxToScreen_Y(VitalsDisplay_Spacing_Y(3)));
            w = QUOTE(ACM_AED_pxToScreen_W(115));
            h = QUOTE(ACM_AED_pxToScreen_H(93));
            colorText[] = NIBP_COLOR;
            text = "0";
        };
        class NIBP_D_Vitals_Display: SpO2_Vitals_Display {
            idc = IDC_VITALSDISPLAY_NIBP_D;
            y = QUOTE(ACM_AED_pxToScreen_Y((VitalsDisplay_Spacing_Y(3) + 55)));
            colorText[] = NIBP_COLOR;
            text = "0";
        };
        class NIBP_Mean_Vitals_Display: NIBP_D_Vitals_Display {
            idc = IDC_VITALSDISPLAY_NIBP_M;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X - 48)));
            y = QUOTE(ACM_AED_pxToScreen_Y((VitalsDisplay_Spacing_Y(3) + 68)));
            w = QUOTE(ACM_AED_pxToScreen_W(100));
            h = QUOTE(ACM_AED_pxToScreen_H(90));
            sizeEx = QUOTE(ACM_GRID_H * 0.8 * (0.55 / (getResolution select 5)));
            text = "0";
        };

        class EKG_Line_0: RscLine {
            idc = IDC_EKG_LINE_0;
            x = QUOTE(ACM_AED_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(ACM_AED_pxToScreen_Y(EKG_Line_Y(0)));
            w = QUOTE(ACM_AED_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(ACM_AED_pxToScreen_H(0));
            colorBackground[] = {0,0,0,0};
            colorText[] = HR_COLOR;
            text = "";
        };
        EKG_LINES
        class EKG_Dot_0: RscText {
            idc = IDC_EKG_DOT_0;
            x = QUOTE(ACM_AED_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(ACM_AED_pxToScreen_Y(EKG_Line_Y(0)));
            w = QUOTE(ACM_AED_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(ACM_AED_pxToScreen_H(2));
            colorBackground[] = HR_COLOR;
            text = "";
        };
        EKG_DOTS
        class PO_Line_0: RscLine {
            idc = IDC_PO_LINE_0;
            x = QUOTE(ACM_AED_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(ACM_AED_pxToScreen_Y(EKG_Line_Y(AED_PO_Y_SPACING)));
            w = QUOTE(ACM_AED_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(ACM_AED_pxToScreen_H(0));
            colorBackground[] = {0,0,0,0};
            colorText[] = SPO2_COLOR;
            text = "";
        };
        PO_LINES
        class PO_Dot_0: RscText {
            idc = IDC_PO_DOT_0;
            x = QUOTE(ACM_AED_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(ACM_AED_pxToScreen_Y(EKG_Line_Y(AED_PO_Y_SPACING)));
            w = QUOTE(ACM_AED_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(ACM_AED_pxToScreen_H(2));
            colorBackground[] = SPO2_COLOR;
            text = "";
        };
        PO_DOTS
        class CO_Line_0: RscLine {
            idc = IDC_CO_LINE_0;
            x = QUOTE(ACM_AED_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(ACM_AED_pxToScreen_Y(EKG_Line_Y(AED_CO_Y_SPACING)));
            w = QUOTE(ACM_AED_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(ACM_AED_pxToScreen_H(0));
            colorBackground[] = {0,0,0,0};
            colorText[] = CO2_COLOR;
            text = "";
        };
        CO_LINES
        class CO_Dot_0: RscText {
            idc = IDC_CO_DOT_0;
            x = QUOTE(ACM_AED_pxToScreen_X(EKG_Line_X(0)));
            y = QUOTE(ACM_AED_pxToScreen_Y(EKG_Line_Y(AED_CO_Y_SPACING)));
            w = QUOTE(ACM_AED_pxToScreen_W(EKG_ColumnWidth));
            h = QUOTE(ACM_AED_pxToScreen_H(2));
            colorBackground[] = CO2_COLOR;
            text = "";
        };
        CO_DOTS
        class CO_Scale_Line_0: RscText {
            idc = IDC_CO_Scale_Line_0;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X + 855)));
            y = QUOTE(ACM_AED_pxToScreen_Y(AED_CO_SCALE_Y(0)));
            w = QUOTE(ACM_AED_pxToScreen_W(25));
            h = QUOTE(ACM_AED_pxToScreen_H(2));
            colorBackground[] = CO2_COLOR;
            text = "";
        };
        class CO_Scale_Line_1: CO_Scale_Line_0 {
            idc = IDC_CO_Scale_Line_1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X + 870)));
            y = QUOTE(ACM_AED_pxToScreen_Y(AED_CO_SCALE_Y(1)));
            w = QUOTE(ACM_AED_pxToScreen_W(10));
        };
        class CO_Scale_Line_2: CO_Scale_Line_1 {
            idc = IDC_CO_Scale_Line_2;
            y = QUOTE(ACM_AED_pxToScreen_Y(AED_CO_SCALE_Y(2)));
        };
        class CO_Scale_Line_3: CO_Scale_Line_1 {
            idc = IDC_CO_Scale_Line_3;
            y = QUOTE(ACM_AED_pxToScreen_Y(AED_CO_SCALE_Y(3)));
        };
        class CO_Scale_Line_4: CO_Scale_Line_1 {
            idc = IDC_CO_Scale_Line_4;
            y = QUOTE(ACM_AED_pxToScreen_Y(AED_CO_SCALE_Y(4)));
        };
        class CO_Scale_Line_5: CO_Scale_Line_0 {
            idc = IDC_CO_Scale_Line_5;
            y = QUOTE(ACM_AED_pxToScreen_Y(AED_CO_SCALE_Y(5)));
        };
        class CO_Scale_Text_0: RscText {
            idc = IDC_CO_Scale_Text_0;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_TOPLEFT_X + 845)));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_CO_SCALE_Y(1) + 10)));
            w = QUOTE(ACM_AED_pxToScreen_W(30));
            h = QUOTE(ACM_AED_pxToScreen_H(20));
            font = "RobotoCondensed";
            shadow = 0;
            type = 0;
            style = 1;
            colorText[] = CO2_COLOR;
            sizeEx = QUOTE(ACM_GRID_H * 0.4 * (0.55 / (getResolution select 5)));
            text = "0";
        };
        class CO_Scale_Text_50: CO_Scale_Text_0 {
            idc = IDC_CO_Scale_Text_50;
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_CO_SCALE_Y(5) + 2)));
            text = "50";
        };
        class AEDBackground: RscPicture {
            idc = -1;
            x = QUOTE(ACM_GUI_AED_GRID_X);
            y = QUOTE(ACM_GUI_AED_GRID_Y);
            w = QUOTE(ACM_GUI_AED_GRID_W * ACM_GUI_AED_SIZEM);
            h = QUOTE(ACM_GUI_AED_GRID_H * ACM_GUI_AED_SIZEM);
            type = 0;
            style = 48;
            size = 0;
            text = QPATHTOF(ui\lifepak\background_ca.paa);
        };
    };

    class Controls {
        class Button_Power: RscButton {
            text = "";
            colorText[] = {1,1,1,0};
            colorDisabled[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            colorBackgroundDisabled[] = {1,1,1,0};
            colorBackgroundActive[] = {1,1,1,0};
            colorFocused[] = {1,1,1,0};
            colorBorder[] = {0,0,0,0};
            soundEnter[] = {};
            soundPush[] = {};
            soundEscape[] = {};
            idc = -1;
            style = 0;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_BUTTON_TOPLEFT_X + 189)));
            y = QUOTE(ACM_AED_pxToScreen_Y(AED_BUTTON_TOPLEFT_Y));
            w = QUOTE(ACM_AED_pxToScreen_W(AED_BUTTON_W));
            h = QUOTE(ACM_AED_pxToScreen_H(AED_BUTTON_H));
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            onButtonClick = "";
            tooltip = "";
        };
        class Button_CPR: Button_Power {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X(AED_BUTTON_TOPLEFT_X));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_BUTTON_TOPLEFT_Y + AED_BUTTON_Spacing_V)));
            onButtonClick = QUOTE([GVAR(AED_Monitor_Target)] call FUNC(AED_Button_CPR));
            tooltip = "CPR Mode Toggle";
        };
        class Button_Analyze: Button_CPR {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X(AED_BUTTON_TOPLEFT_X));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_BUTTON_TOPLEFT_Y + (AED_BUTTON_Spacing_V * 2) - 15)));
            onButtonClick = QUOTE([GVAR(AED_Monitor_Target)] call FUNC(AED_Button_Analyze));
            tooltip = "Analyze Rhythm";
        };
        class Button_NIBP: Button_CPR {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_BUTTON_TOPLEFT_X + 3)));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_BUTTON_TOPLEFT_Y + (AED_BUTTON_Spacing_V * 4) + 27)));
            onButtonClick = QUOTE([GVAR(AED_Monitor_Target)] call FUNC(AED_Button_MeasureBP));
            tooltip = "Measure NIBP";
        };
        class Button_Alarms: Button_CPR {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_BUTTON_TOPLEFT_X + 3)));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_BUTTON_TOPLEFT_Y + (AED_BUTTON_Spacing_V * 5) + 12)));
            onButtonClick = QUOTE([GVAR(AED_Monitor_Target)] call FUNC(AED_Button_MuteAlarms));
            tooltip = "Toggle Alarms";
        };
        class Button_EnergySelect: Button_Power {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_BUTTON_TOPLEFT_X + 189)));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_BUTTON_TOPLEFT_Y + AED_BUTTON_Spacing_V)));
            onButtonClick = "";
            tooltip = "";
        };
        class Button_Charge: Button_Power {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_BUTTON_TOPLEFT_X + 189)));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_BUTTON_TOPLEFT_Y + (AED_BUTTON_Spacing_V * 2) - 16)));
            onButtonClick = QUOTE([GVAR(AED_Monitor_Target)] call FUNC(AED_Button_ManualCharge));
            tooltip = "Manual Charge";
        };
        class Button_Shock: Button_Power {
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_BUTTON_TOPLEFT_X + 223)));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_BUTTON_TOPLEFT_Y + (AED_BUTTON_Spacing_V * 3) - 25)));
            w = QUOTE(ACM_AED_pxToScreen_W(80));
            h = QUOTE(ACM_AED_pxToScreen_H(80));
            onButtonClick = QUOTE([GVAR(AED_Monitor_Target)] call FUNC(AED_Button_Shock));
            tooltip = "Administer Shock";
        };
        class Button_SpeedDial: Button_Power {
            soundClick[] = {QPATHTO_R(sound\aed_button_speeddial.wav), 1, 1};
            idc = -1;
            x = QUOTE(ACM_AED_pxToScreen_X((AED_BUTTON_TOPLEFT_X + 140)));
            y = QUOTE(ACM_AED_pxToScreen_Y((AED_BUTTON_TOPLEFT_Y + 670)));
            w = QUOTE(ACM_AED_pxToScreen_W(180));
            h = QUOTE(ACM_AED_pxToScreen_H(180));
            onButtonClick = QUOTE([GVAR(AED_Monitor_Target)] call FUNC(AED_Button_SpeedDial));
            tooltip = "Speed Dial";
        };
    };
};
