#include "TransfusionMenu_defines.hpp"

class RscPicture;
class RscLine;
class RscText;
class RscBackground;
class RscButton;
class RscButtonMenu;
class RscPictureKeepAspect;
class RscListBox;

class GVAR(TransfusionMenu_Dialog) {
    idd = IDC_TRANSFUSIONMENU;
    movingEnable = 0;
    onLoad = "";
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(TransfusionMenu_DLG),nil)]);
    objects[] = {};

    class ControlsBackground {
        class MenuBackground: RscText {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 4));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 4));
            w = QUOTE(safezoneW / 2);
            h = QUOTE(safezoneH / 2);
            colorBackground[] = {0,0,0,0.7};
        };
        class PatientName: RscText {
            idc = IDC_TRANSFUSIONMENU_PATIENTNAME;
            style = ST_CENTER;
            font = "RobotoCondensed";
            x = QUOTE(safezoneX);
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 4.1));
            w = QUOTE(safezoneW);
            h = QUOTE(safezoneH / 20);
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            text = "";
            lineSpacing = 0;
            sizeEx = QUOTE(GUI_GRID_H * 1.8 * NORMALIZE_SIZEEX);
            shadow = 1;
            colorShadow[] = {0,0,0,0.5};
        };
        class SelectedLimbText: PatientName {
            idc = IDC_TRANSFUSIONMENU_SELECTIONTEXT;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 4.2));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 4.2));
            w = QUOTE(safezoneW / 10);
            h = QUOTE(safezoneH / 25);
            text = "";
            sizeEx = QUOTE(GUI_GRID_H * 1.1 * NORMALIZE_SIZEEX);
        };
        class SelectedInventoryText: SelectedLimbText {
            idc = IDC_TRANSFUSIONMENU_SELECTION_INV_TEXT;
            x = QUOTE(safezoneX + (safezoneW / 2) + (safezoneW / 7.2));
            text = __EVAL(call compile QUOTE(format [ARR_2(C_LLSTRING(TransfusionMenu_InventoryTarget),C_LLSTRING(TransfusionMenu_InventoryTarget_Self))]));
        };
        class BodyBackground: RscPictureKeepAspect {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 8));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 4.5));
            w = QUOTE(safezoneW / 4);
            h = QUOTE(safezoneH / 2);
            type = 0;
            size = 0;
            text = QPATHTOEF(gui,ui\body_background.paa);
        };
        /*class SelectionRemainingText: PatientName {
            idc = -1;
            style = 0;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 7.7));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 6));
            w = QUOTE(safezoneW / 20);
            h = QUOTE(safezoneH / 40);
            text = "Remaining: 1000ml";
            sizeEx = QUOTE(GUI_GRID_H * 0.65 * NORMALIZE_SIZEEX);
        };*/
        class BodyBackground_IO_Torso: BodyBackground {
            idc = IDC_TRANSFUSIONMENU_BG_IO_TORSO;
            text = QPATHTOEF(gui,data\body_image\torso_fast_io.paa);
            colorText[] = COLOR_CIRCULATION;
        };
        class BodyBackground_IO_RightArm: BodyBackground_IO_Torso {
            idc = IDC_TRANSFUSIONMENU_BG_IO_RIGHTARM;
            text = QPATHTOEF(gui,data\body_image\rightarm_io.paa);
        };
        class BodyBackground_IO_LeftArm: BodyBackground_IO_Torso {
            idc = IDC_TRANSFUSIONMENU_BG_IO_LEFTARM;
            text = QPATHTOEF(gui,data\body_image\leftarm_io.paa);
        };
        class BodyBackground_IO_RightLeg: BodyBackground_IO_Torso {
            idc = IDC_TRANSFUSIONMENU_BG_IO_RIGHTLEG;
            text = QPATHTOEF(gui,data\body_image\rightleg_io.paa);
        };
        class BodyBackground_IO_LeftLeg: BodyBackground_IO_Torso {
            idc = IDC_TRANSFUSIONMENU_BG_IO_LEFTLEG;
            text = QPATHTOEF(gui,data\body_image\leftleg_io.paa);
        };
        BODY_BACKGROUND_IV(RightArm,Upper,IDC_TRANSFUSIONMENU_BG_IV_RIGHTARM_UPPER);
        BODY_BACKGROUND_IV(RightArm,Middle,IDC_TRANSFUSIONMENU_BG_IV_RIGHTARM_MIDDLE);
        BODY_BACKGROUND_IV(RightArm,Lower,IDC_TRANSFUSIONMENU_BG_IV_RIGHTARM_LOWER);

        BODY_BACKGROUND_IV(LeftArm,Upper,IDC_TRANSFUSIONMENU_BG_IV_LEFTARM_UPPER);
        BODY_BACKGROUND_IV(LeftArm,Middle,IDC_TRANSFUSIONMENU_BG_IV_LEFTARM_MIDDLE);
        BODY_BACKGROUND_IV(LeftArm,Lower,IDC_TRANSFUSIONMENU_BG_IV_LEFTARM_LOWER);

        BODY_BACKGROUND_IV(RightLeg,Upper,IDC_TRANSFUSIONMENU_BG_IV_RIGHTLEG_UPPER);
        BODY_BACKGROUND_IV(RightLeg,Middle,IDC_TRANSFUSIONMENU_BG_IV_RIGHTLEG_MIDDLE);
        BODY_BACKGROUND_IV(RightLeg,Lower,IDC_TRANSFUSIONMENU_BG_IV_RIGHTLEG_LOWER);

        BODY_BACKGROUND_IV(LeftLeg,Upper,IDC_TRANSFUSIONMENU_BG_IV_LEFTLEG_UPPER);
        BODY_BACKGROUND_IV(LeftLeg,Middle,IDC_TRANSFUSIONMENU_BG_IV_LEFTLEG_MIDDLE);
        BODY_BACKGROUND_IV(LeftLeg,Lower,IDC_TRANSFUSIONMENU_BG_IV_LEFTLEG_LOWER);
    };
    class Controls {
        class BodyPart_Torso: RscButton {
            text = "";
            colorText[] = {1,1,1,0};
            colorDisabled[] = {1,1,1,0};
            colorBackground[] = {1,1,1,0};
            colorBackgroundDisabled[] = {1,1,1,0};
            colorBackgroundActive[] = {1,1,1,0};
            colorFocused[] = {1,1,1,0};
            colorBorder[] = {0,0,0,0};
            idc = -1;
            style = 0;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 54));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 9));
            w = QUOTE(safezoneW / 27);
            h = QUOTE(safezoneH / 7.15);
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            tooltip = ACECSTRING(medical_gui,Torso);
            action = QUOTE([ARR_2('body',0)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        /*class BodyPart_Head: BodyPart_Torso {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 68));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 5.9));
            w = QUOTE(safezoneW / 34);
            h = QUOTE(safezoneH / 17.1);
            tooltip = "Head";
        };*/
        class BodyPart_RightArm_Upper: BodyPart_Torso {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 22));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 9.4));
            w = QUOTE(safezoneW / 37);
            h = QUOTE(safezoneH / 19);
            tooltip = __EVAL(call compile BODYPART_PART(RightArm,Upper));
            action = QUOTE([ARR_2('rightarm',0)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_RightArm_Middle: BodyPart_RightArm_Upper {
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 18.8));
            tooltip = __EVAL(call compile BODYPART_PART(RightArm,Middle));
            action = QUOTE([ARR_2('rightarm',1)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_RightArm_Lower: BodyPart_RightArm_Upper {
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 1100));
            tooltip = __EVAL(call compile BODYPART_PART(RightArm,Lower));
            action = QUOTE([ARR_2('rightarm',2)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_LeftArm_Upper: BodyPart_RightArm_Upper {
            x = QUOTE(safezoneY + (safezoneH / 2) + (safezoneW / 53));
            tooltip = __EVAL(call compile BODYPART_PART(LeftArm,Upper));
            action = QUOTE([ARR_2('leftarm',0)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_LeftArm_Middle: BodyPart_LeftArm_Upper {
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 18.8));
            tooltip = __EVAL(call compile BODYPART_PART(LeftArm,Middle));
            action = QUOTE([ARR_2('leftarm',1)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_LeftArm_Lower: BodyPart_LeftArm_Upper {
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 1100));
            tooltip = __EVAL(call compile BODYPART_PART(LeftArm,Lower));
            action = QUOTE([ARR_2('leftarm',2)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_RightLeg_Upper: BodyPart_Torso {
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 47));
            y = QUOTE(safezoneY + (safezoneH / 2) + (safezoneH / 35));
            w = QUOTE(safezoneW / 47);
            h = QUOTE(safezoneH / 16);
            tooltip = __EVAL(call compile BODYPART_PART(RightLeg,Upper));
            action = QUOTE([ARR_2('rightleg',0)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_RightLeg_Middle: BodyPart_RightLeg_Upper {
            y = QUOTE(safezoneX + (safezoneW / 2) + (safezoneH / 11));
            tooltip = __EVAL(call compile BODYPART_PART(RightLeg,Middle));
            action = QUOTE([ARR_2('rightleg',1)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_RightLeg_Lower: BodyPart_RightLeg_Upper {
            y = QUOTE(safezoneX + (safezoneW / 2) + (safezoneH / 6.55));
            tooltip = __EVAL(call compile BODYPART_PART(RightLeg,Lower));
            action = QUOTE([ARR_2('rightleg',2)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_LeftLeg_Upper: BodyPart_RightLeg_Upper {
            x = QUOTE(safezoneX + (safezoneW / 2) + (safezoneW / 5000));
            tooltip = __EVAL(call compile BODYPART_PART(LeftLeg,Upper));
            action = QUOTE([ARR_2('leftleg',0)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_LeftLeg_Middle: BodyPart_LeftLeg_Upper {
            y = QUOTE(safezoneX + (safezoneW / 2) + (safezoneH / 11));
            tooltip = __EVAL(call compile BODYPART_PART(LeftLeg,Middle));
            action = QUOTE([ARR_2('leftleg',1)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class BodyPart_LeftLeg_Lower: BodyPart_LeftLeg_Upper {
            y = QUOTE(safezoneX + (safezoneW / 2) + (safezoneH / 6.55));
            tooltip = __EVAL(call compile BODYPART_PART(LeftLeg,Lower));
            action = QUOTE([ARR_2('leftleg',2)] call FUNC(TransfusionMenu_SelectBodyPart));
        };
        class LeftPanelList: RscListBox
        {
            idc = IDC_TRANSFUSIONMENU_LEFTLISTPANEL;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 4.1));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 6));
            w = QUOTE(safezoneW / 9);
            h = QUOTE(safezoneH / 2.5);
            rowHeight = QUOTE(safezoneH / 20);
            colorText[] = {1,1,1,1};
            colorSelect[] = {0,0,0,1};
            colorSelect2[] = {0,0,0,1};
            colorBackground[] = {0,0,0,0.1};
            colorSelectBackground[] = {0.7,0.7,0.7,1};
            colorSelectBackground2[] = {0.7,0.7,0.7,1};
            sizeEx = QUOTE(GUI_GRID_H * 0.9 * NORMALIZE_SIZEEX);
            class Items {};
        };
        class ToggleIV: RscButtonMenu {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 6.9));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 4.3));
            w = QUOTE(safezoneW / 65);
            h = QUOTE(safezoneH / 35);
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            action = QUOTE(call FUNC(TransfusionMenu_ToggleIV));
            textureNoShortcut = QPATHTOF(ui\transfusionmenu\ivtoggle_ca.paa);
            tooltip = CSTRING(TransfusionMenu_ToggleIV);
            colorBackground[] = {1,1,1,0};
            colorBackgroundFocused[] = {1,1,1,0};
            period = 0;
            periodFocus = 0;
            periodOver = 0;
            class ShortcutPos
            {
                left = 0;
                top = 0;
                w = QUOTE(safezoneW / 55);
                h = QUOTE(safezoneH / 30);
            };
        };
        class StopTransfusionButton: RscButton {
            text = "";
            colorText[] = {1,1,1,1};
            colorDisabled[] = {1,1,1,1};
            colorBackground[] = {0,0,0,1};
            colorBackgroundDisabled[] = {0,0,0,1};
            colorBackgroundActive[] = {0,0,0,1};
            colorFocused[] = {0,0,0,1};
            colorBorder[] = {0,0,0,0};
            idc = IDC_TRANSFUSIONMENU_BUTTON_STOPIV;
            style = ST_CENTER;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 4.35));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 5.1));
            w = QUOTE(safezoneW / 12);
            h = QUOTE(safezoneH / 40);
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = QUOTE(GUI_GRID_H * 0.9 * NORMALIZE_SIZEEX);
            action = QUOTE(call FUNC(TransfusionMenu_ToggleIVFlow));
            tooltip = "";
        };
        class MoveBagButton: StopTransfusionButton {
            text = CSTRING(TransfusionMenu_MoveBag_Display);
            idc = IDC_TRANSFUSIONMENU_BUTTON_MOVEBAG;
            x = QUOTE(safezoneX + (safezoneW / 2) - (safezoneW / 7.8));
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 6));
            w = QUOTE(safezoneW / 22);
            action = QUOTE(call FUNC(TransfusionMenu_MoveBag));
            tooltip = CSTRING(TransfusionMenu_MoveBag_ToolTip);
        };
        class RemoveBagButton: MoveBagButton {
            text = CSTRING(TransfusionMenu_RemoveBag_Display);
            idc = IDC_TRANSFUSIONMENU_BUTTON_REMOVEBAG;
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 7.5));
            action = QUOTE(call FUNC(TransfusionMenu_RemoveBag));
            tooltip = CSTRING(TransfusionMenu_RemoveBag_ToolTip);
        };
        /*class InfuseBagButton: MoveBagButton {
            text = "Infuse";
            idc = -1;
            y = QUOTE(safezoneY + (safezoneH / 2) - (safezoneH / 10));
            action = "";
            tooltip = "Infuse medication into fluid bag";
        };*/

        class RightPanelList: LeftPanelList
        {
            idc = IDC_TRANSFUSIONMENU_RIGHTLISTPANEL;
            x = QUOTE(safezoneX + (safezoneW / 2) + (safezoneW / 7.5));
        };
        class SwitchTargetInventory: ToggleIV {
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) + (safezoneW / 7.8));
            action = QUOTE(call FUNC(TransfusionMenu_SwitchTargetInventory));
            textureNoShortcut = QPATHTOF(ui\transfusionmenu\inventory_select_ca.paa);
            tooltip = CSTRING(TransfusionMenu_SwitchTargetInventory);
        };
        class AddBagButton: StopTransfusionButton {
            text = CSTRING(TransfusionMenu_AddBag_Display);
            idc = -1;
            x = QUOTE(safezoneX + (safezoneW / 2) + (safezoneW / 6.8));
            action = QUOTE(call FUNC(TransfusionMenu_AddBag));
            tooltip = CSTRING(TransfusionMenu_AddBag_ToolTip);
        };
    };
};
