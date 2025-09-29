#include "SurgicalAirway_defines.hpp"

class GVAR(SurgicalAirway_Dialog) {
    idd = IDC_SURGICAL_AIRWAY;
    movingEnable = 0;
    onLoad = "";
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(SurgicalAirway_DLG),nil)]);
    objects[] = {};

    class ControlsBackground {
        class BodyBackground: RscPicture {
            idc = -1;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X_CENTER(100,20));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y_CENTER(75,10));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(100));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(75));
            type = 0;
            size = 0;
            text = QPATHTOF(ui\surgical_airway\body_background.paa);
        };
        class Visual_IncisionGroup: RscControlsGroupNoScrollbars {
            idc = IDC_SURGICAL_AIRWAY_VISUAL_INCISIONGROUP;
            x = "0";
            y = "0";
        };
        class Visual_Incision: RscPicture {
            idc = IDC_SURGICAL_AIRWAY_VISUAL_INCISIONBIG;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(0));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(7.65));
            w = QUOTE(ACM_SURGICAL_AIRWAY_VISUAL_INCISION_W);
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(4.725));
            type = 0;
            size = 0;
            text = QPATHTOF(ui\surgical_airway\incision_0_0.paa);
            show = 0;
        };
        class Visual_PlacedHook: RscPicture {
            idc = IDC_SURGICAL_AIRWAY_VISUAL_PLACED_HOOK;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(0));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(0.6));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(25.2));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(18.9));
            type = 0;
            size = 0;
            text = QPATHTOF(ui\surgical_airway\placed_hook.paa);
            show = 0;
        };
        class Visual_PlacedTube: Visual_PlacedHook {
            idc = IDC_SURGICAL_AIRWAY_VISUAL_PLACED_TUBE;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(-5.55));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(-9.25));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(51.2)); //50.4
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(38.4)); //37.8
            text = QPATHTOF(ui\surgical_airway\placed_tube_0.paa);
        };
    };
    class Controls {
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
            text = CSTRING(SurgicalAirway_ActionProgress);
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
            idc = IDC_SURGICAL_AIRWAY_TARGET;
            h = QUOTE(safeZoneH / 6);
            text = "";
        };

        class Space_ActionArea: RscText {
            idc = IDC_SURGICAL_AIRWAY_SPACE_ACTIONAREA;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(10));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(4));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(20));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(14));
            colorBackground[] = {0.9,0.9,0.3,0.5};
            show = 0;
        };

        class Space_Landmark_Shape: Space_ActionArea {
            idc = IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_SHAPE;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(18.1));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(7.1));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(5));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(3.9));
            colorBackground[] = {0.4,0.1,0.2,1};
        };

        class Space_Landmark_Shape2: Space_Landmark_Shape {
            idc = IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_SHAPE2;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(18.8));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(10.8));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(3.5));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(7));
            colorBackground[] = {0.3,0,0.1,1};
        };

        class Space_Landmark_Upper: Space_ActionArea {
            idc = IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_UPPER;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(17.8));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(7.7));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(5.5));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(2));
            colorBackground[] = {0.7,0.1,0.1,1};
        };

        class Space_Landmark_UpperMiddle: Space_Landmark_Upper {
            idc = IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_UPPERMIDDLE;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(20.35));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(7.4));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(0.5));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(2.3));
            colorBackground[] = {0.8,0.7,0.7,1};
        };

        class Space_Landmark_Lower: Space_Landmark_Upper {
            idc = IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_LOWER;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(18.5));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(10.2));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(4.2));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(1.4));
        };

        class Space_Landmark_EntryArea: Space_Landmark_Upper {
            idc = IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_ENTRYAREA;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(18.4));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(9.5));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(4.4));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(1));
            colorBackground[] = {0.7,0.5,0.5,1};
        };

        class Space_Landmark_Entry: Space_Landmark_Upper {
            idc = IDC_SURGICAL_AIRWAY_SPACE_LANDMARK_ENTRY;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(19.5));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(9.7));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(2.2));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(0.7));
            colorBackground[] = {0.6,0,0,1};
        };

        class Space_Incision_Vertical: RscText {
            idc = IDC_SURGICAL_AIRWAY_SPACE_INCISION_VERTICAL;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(20.35));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(9.1));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(0.5));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(1.9));
            colorBackground[] = {0.6,0.6,0,1};
            show = 0;
        };

        class Space_Incision_Horizontal: Space_Incision_Vertical {
            idc = IDC_SURGICAL_AIRWAY_SPACE_INCISION_HORIZONTAL;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(20));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(9.7));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(1.2));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(0.7));
            colorBackground[] = {0.9,0.7,0.3,1};
        };

        class Space_CricEntry: Space_Incision_Vertical {
            idc = IDC_SURGICAL_AIRWAY_SPACE_CRICENTRY;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(19.6));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(9));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(2));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(2));
            colorBackground[] = {0.8,0.8,0.2,1};
        };

        class Space_Incision: RscText {
            idc = IDC_SURGICAL_AIRWAY_SPACE_INCISION;
            x = "0";
            y = "0";
            w = QUOTE(ACM_SURGICAL_AIRWAY_SPACE_INCISION_W);
            h = QUOTE(ACM_SURGICAL_AIRWAY_SPACE_INCISION_H);
            colorBackground[] = {1,0.6,0.6,0.5};
            show = 0;
        };

        class Inventory_Scalpel_ImageBG: RscText {
            idc = -1;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X_INV(1.285));
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_SCALPEL_Y);
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W_INV(0.115));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H_INV(0.115));
            colorBackground[] = {0,0,0,0.7};
        };

        class Inventory_Hook_ImageBG: Inventory_Scalpel_ImageBG {
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_HOOK_Y);
        };

        class Inventory_Tube_ImageBG: Inventory_Scalpel_ImageBG {
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_TUBE_Y);
        };

        class Inventory_Syringe_ImageBG: Inventory_Scalpel_ImageBG {
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_SYRINGE_Y);
        };

        class Inventory_Strap_ImageBG: Inventory_Scalpel_ImageBG {
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_STRAP_Y);
        };

        class Inventory_Scalpel_Image: RscPicture {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_SCALPEL_IMG;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X_INV(1.285));
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_SCALPEL_Y);
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W_INV(0.115));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H_INV(0.115));
            type = 0;
            size = 0;
            text = QPATHTOF(ui\surgical_airway\inv_scalpel.paa);
        };

        class Inventory_Hook_Image: Inventory_Scalpel_Image {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_HOOK_IMG;
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_HOOK_Y);
            text = QPATHTOF(ui\surgical_airway\inv_hook.paa);
        };

        class Inventory_Tube_Image: Inventory_Scalpel_Image {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_TUBE_IMG;
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_TUBE_Y);
            text = QPATHTOF(ui\surgical_airway\inv_tube.paa);
        };

        class Inventory_Syringe_Image: Inventory_Scalpel_Image {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_SYRINGE_IMG;
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_SYRINGE_Y);
            text = QPATHTOF(ui\surgical_airway\inv_syringe.paa);
        };

        class Inventory_Strap_Image: Inventory_Scalpel_Image {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_STRAP_IMG;
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_STRAP_Y);
            text = QPATHTOF(ui\surgical_airway\inv_strap.paa);
        };

        class Inventory_Scalpel: RscButton {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_SCALPEL;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X_INV(1.285));
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_SCALPEL_Y);
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W_INV(0.115));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H_INV(0.115));
            colorText[] = {0,0,0,0};
            colorDisabled[] = {0,0,0,0};
            colorBackground[] = {0,0,0,0};
            colorBackgroundDisabled[] = {0,0,0,0};
            colorBackgroundActive[] = {0,0,0,0};
            colorFocused[] = {0,0,0,0};
            colorBorder[] = {0,0,0,0};
            soundEnter[] = {};
            soundPush[] = {};
            soundEscape[] = {};
            style = 0;
            shadow = 0;
            font = "RobotoCondensed";
            sizeEx = "0";
            onButtonClick = QUOTE([SURGICAL_AIRWAY_SELECTED_SCALPEL] call FUNC(SurgicalAirway_select));
            tooltip = CSTRING(SurgicalAirway_Scalpel);
            text = "";
        };

        class Inventory_Hook: Inventory_Scalpel {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_HOOK;
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_HOOK_Y);
            tooltip = CSTRING(SurgicalAirway_Hook);
            onButtonClick = QUOTE([SURGICAL_AIRWAY_SELECTED_HOOK] call FUNC(SurgicalAirway_select));
        };

        class Inventory_Tube: Inventory_Scalpel {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_TUBE;
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_TUBE_Y);
            tooltip = CSTRING(SurgicalAirway_Tube);
            onButtonClick = QUOTE([SURGICAL_AIRWAY_SELECTED_TUBE] call FUNC(SurgicalAirway_select));
        };

        class Inventory_Syringe: Inventory_Scalpel {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_SYRINGE;
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_SYRINGE_Y);
            tooltip = CSTRING(SurgicalAirway_Syringe);
            onButtonClick = QUOTE([SURGICAL_AIRWAY_SELECTED_SYRINGE] call FUNC(SurgicalAirway_select));
        };

        class Inventory_Strap: Inventory_Scalpel {
            idc = IDC_SURGICAL_AIRWAY_INVBUTTON_STRAP;
            y = QUOTE(SURGICAL_AIRWAY_BUTTON_STRAP_Y);
            tooltip = CSTRING(SurgicalAirway_Strap);
            onButtonClick = QUOTE([SURGICAL_AIRWAY_SELECTED_STRAP] call FUNC(SurgicalAirway_select));
        };

        class Feedback_Palpate: RscPicture {
            idc = IDC_SURGICAL_AIRWAY_PALPATE;
            x = "0";
            y = "0";
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(0.6));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(0.6));
            type = 0;
            size = 0;
            text = QPATHTOF(ui\surgical_airway\feedback_marker.paa);
            colorText[] = {1,0,0,0.7};
            show = 0;
        };

        class Visual_ActiveItem: RscPicture {
            idc = IDC_SURGICAL_AIRWAY_VISUAL_ACTIVEITEM;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(0));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(0));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(25));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(25));
            type = 0;
            size = 0;
            text = "";
            show = 0;
        };

        class Action_LiftIncision: RscButton {
            idc = IDC_SURGICAL_AIRWAY_ACTION_LIFTINCISION;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(19.6));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(9));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(2));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(2));
            colorText[] = {0,0,0,0};
            colorDisabled[] = {0,0,0,0};
            colorBackground[] = {0,0,0,0};
            colorBackgroundDisabled[] = {0,0,0,0};
            colorBackgroundActive[] = {0,0,0,0};
            colorFocused[] = {0,0,0,0};
            colorBorder[] = {0,0,0,0};
            soundClick[] = {};
            soundEnter[] = {};
            soundPush[] = {};
            soundEscape[] = {};
            style = 0;
            shadow = 0;
            sizeEx = "0";
            onButtonClick = QUOTE([1] call FUNC(SurgicalAirway_action));
            tooltip = CSTRING(SurgicalAirway_LiftIncision);
            text = "";
            show = 0;
        };

        class Action_RemoveHook: Action_LiftIncision {
            idc = IDC_SURGICAL_AIRWAY_ACTION_REMOVEHOOK;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(20.2));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(10));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(5.5));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(8.5));
            onButtonClick = QUOTE([3] call FUNC(SurgicalAirway_action));
            tooltip = CSTRING(SurgicalAirway_RemoveHook);
        };

        class Action_InsertTube: Action_LiftIncision {
            idc = IDC_SURGICAL_AIRWAY_ACTION_INSERTTUBE;
            onButtonClick = QUOTE([2] call FUNC(SurgicalAirway_action));
            tooltip = CSTRING(SurgicalAirway_InsertTube);
        };

        class Action_InflateCuff: Action_LiftIncision {
            idc = IDC_SURGICAL_AIRWAY_ACTION_INFLATECUFF;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(3.5));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(17.6));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(6));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(2));
            onButtonClick = QUOTE([4] call FUNC(SurgicalAirway_action));
            tooltip = CSTRING(SurgicalAirway_InflateTubeCuff);
        };

        class Action_RemoveStylet: Action_LiftIncision {
            idc = IDC_SURGICAL_AIRWAY_ACTION_REMOVESTYLET;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(18.6));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(8.8));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(3));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(3));
            onButtonClick = QUOTE([5] call FUNC(SurgicalAirway_action));
            tooltip = CSTRING(SurgicalAirway_RemoveTubeStylet);
        };

        class Action_ConnectStrap: Action_LiftIncision {
            idc = IDC_SURGICAL_AIRWAY_ACTION_CONNECTSTRAP;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(12.7));
            y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(9));
            w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(5.4));
            h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(2.5));
            onButtonClick = QUOTE([6] call FUNC(SurgicalAirway_action));
            tooltip = CSTRING(SurgicalAirway_ConnectStrap);
        };

        class Action_SecureStrap: Action_ConnectStrap {
            idc = IDC_SURGICAL_AIRWAY_ACTION_SECURESTRAP;
            x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(22));
            onButtonClick = QUOTE([7] call FUNC(SurgicalAirway_action));
            tooltip = CSTRING(SurgicalAirway_SecureStrap);
        };
    };
};

class ACM_SurgicalAirway_VisualIncision: RscPicture {
    idc = -1;
    x = QUOTE(ACM_SURGICAL_AIRWAY_POS_X(0));
    y = QUOTE(ACM_SURGICAL_AIRWAY_POS_Y(0));
    w = QUOTE(ACM_SURGICAL_AIRWAY_POS_W(6.3));
    h = QUOTE(ACM_SURGICAL_AIRWAY_POS_H(4.725));
    type = 0;
    size = 0;
    text = QPATHTOF(ui\surgical_airway\incision_vertical.paa);
    show = 1;
};