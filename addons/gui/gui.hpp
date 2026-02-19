class RscText;
class RscButton;
class RscPicture;
class RscListBox;
class RscActivePicture;
class RscButtonMenu;
class RscControlsGroup;
class RscControlsGroupNoScrollbars;

#define BODYIMAGE_IV(bodypart,site,sidc) \
    class TRIPLES(bodypart,IV,site): Torso_IO { \
        idc = sidc; \
        text = QPATHTOF(data\body_image\##bodypart##_iv_##site##.paa); \
    }

class ACEGVAR(medical_gui,BodyImage): RscControlsGroupNoScrollbars {
    class Controls {
        class Background;
        class Head: Background {};
        class Torso: Background {};
        class ArmLeft: Background {};
        class ArmRight: Background {};
        class LegLeft: Background {};
        class LegRight: Background {};
        class ArmLeftB: Background {};
        class ArmRightB: ArmLeftB {};
        class LegLeftB: ArmLeftB {};
        class LegRightB: ArmLeftB {};
        class Torso_ChestSeal: Background {
            idc = IDC_BODY_TORSO_CHESTSEAL;
            text = QPATHTOF(data\body_image\torso_chestseal.paa);
            colorText[] = {1, 0.95, 0, 1};
            show = 0;
        };
        class Head_OPA: Torso_ChestSeal {
            idc = IDC_BODY_HEAD_OPA;
            text = QPATHTOF(data\body_image\head_opa.paa);
            colorText[] = {0.19, 0.91, 0.93, 1};
        };
        class Head_NPA: Head_OPA {
            idc = IDC_BODY_HEAD_NPA;
            text = QPATHTOF(data\body_image\head_npa.paa);
        };
        class Head_iGel: Head_OPA {
            idc = IDC_BODY_HEAD_IGEL;
            text = QPATHTOF(data\body_image\head_igel.paa);
        };
        class Head_SurgicalAirway_0: Head_OPA {
            idc = IDC_BODY_HEAD_SURGICAL_AIRWAY_0;
            text = QPATHTOF(data\body_image\head_surgical_airway_0.paa);
        };
        class Head_SurgicalAirway_1: Head_SurgicalAirway_0 {
            idc = IDC_BODY_HEAD_SURGICAL_AIRWAY_1;
            text = QPATHTOF(data\body_image\head_surgical_airway_1.paa);
        };
        class Head_Lozenge: Head_OPA {
            idc = IDC_BODY_HEAD_LOZENGE;
            text = QPATHTOF(data\body_image\head_lozenge.paa);
            colorText[] = COLOR_CIRCULATION;
        };
        class RightArm_PulseOximeter: Background {
            idc = IDC_BODY_RIGHTARM_PULSEOX;
            text = QPATHTOF(data\body_image\rightarm_pulseoximeter.paa);
            colorText[] = {0.3, 0.8, 0.8, 1};
            show = 0;
        };
        class LeftArm_PulseOximeter: RightArm_PulseOximeter {
            idc = IDC_BODY_LEFTARM_PULSEOX;
            text = QPATHTOF(data\body_image\leftarm_pulseoximeter.paa);
        };
        class Torso_AED_Pads: Background {
            idc = IDC_BODY_TORSO_AED_PADS;
            text = QPATHTOF(data\body_image\torso_aed_pads.paa);
            colorText[] = {0.18, 0.6, 0.96, 1};
            show = 0;
        };
        class Head_AED_Capnograph: Torso_AED_Pads {
            idc = IDC_BODY_HEAD_AED_CAPNOGRAPH;
            text = QPATHTOF(data\body_image\head_aed_capnograph.paa);
        };
        class RightArm_AED_PulseOximeter: Torso_AED_Pads {
            idc = IDC_BODY_RIGHTARM_AED_PULSEOX;
            text = QPATHTOF(data\body_image\rightarm_aed_pulseoximeter.paa);
        };
        class LeftArm_AED_PulseOximeter: RightArm_AED_PulseOximeter {
            idc = IDC_BODY_LEFTARM_AED_PULSEOX;
            text = QPATHTOF(data\body_image\leftarm_aed_pulseoximeter.paa);
        };
        class RightArm_AED_PressureCuff: Torso_AED_Pads {
            idc = IDC_BODY_RIGHTARM_AED_PRESSURECUFF;
            text = QPATHTOF(data\body_image\rightarm_aed_pressurecuff.paa);
        };
        class LeftArm_AED_PressureCuff: RightArm_AED_PulseOximeter {
            idc = IDC_BODY_LEFTARM_AED_PRESSURECUFF;
            text = QPATHTOF(data\body_image\leftarm_aed_pressurecuff.paa);
        };
        class Torso_IO: Torso_ChestSeal {
            idc = IDC_BODY_TORSO_IO;
            text = QPATHTOF(data\body_image\torso_fast_io.paa);
            colorText[] = COLOR_CIRCULATION;
        };
        class RightArm_IO: Torso_IO {
            idc = IDC_BODY_RIGHTARM_IO;
            text = QPATHTOF(data\body_image\rightarm_io.paa);
        };
        class LeftArm_IO: RightArm_IO {
            idc = IDC_BODY_LEFTARM_IO;
            text = QPATHTOF(data\body_image\leftarm_io.paa);
        };
        class RightLeg_IO: RightArm_IO {
            idc = IDC_BODY_RIGHTLEG_IO;
            text = QPATHTOF(data\body_image\rightleg_io.paa);
        };
        class LeftLeg_IO: RightArm_IO {
            idc = IDC_BODY_LEFTLEG_IO;
            text = QPATHTOF(data\body_image\leftleg_io.paa);
        };
        BODYIMAGE_IV(RightArm,Upper,IDC_BODY_RIGHTARM_UPPER_IV);
        BODYIMAGE_IV(RightArm,Middle,IDC_BODY_RIGHTARM_MIDDLE_IV);
        BODYIMAGE_IV(RightArm,Lower,IDC_BODY_RIGHTARM_LOWER_IV);

        BODYIMAGE_IV(LeftArm,Upper,IDC_BODY_LEFTARM_UPPER_IV);
        BODYIMAGE_IV(LeftArm,Middle,IDC_BODY_LEFTARM_MIDDLE_IV);
        BODYIMAGE_IV(LeftArm,Lower,IDC_BODY_LEFTARM_LOWER_IV);

        BODYIMAGE_IV(RightLeg,Upper,IDC_BODY_RIGHTLEG_UPPER_IV);
        BODYIMAGE_IV(RightLeg,Middle,IDC_BODY_RIGHTLEG_MIDDLE_IV);
        BODYIMAGE_IV(RightLeg,Lower,IDC_BODY_RIGHTLEG_LOWER_IV);

        BODYIMAGE_IV(LeftLeg,Upper,IDC_BODY_LEFTLEG_UPPER_IV);
        BODYIMAGE_IV(LeftLeg,Middle,IDC_BODY_LEFTLEG_MIDDLE_IV);
        BODYIMAGE_IV(LeftLeg,Lower,IDC_BODY_LEFTLEG_LOWER_IV);
        class RightArm_PressureCuff: Torso_IO {
            idc = IDC_BODY_RIGHTARM_PRESSURECUFF;
            text = QPATHTOF(data\body_image\rightarm_aed_pressurecuff.paa);
        };
        class LeftArm_PressureCuff: Torso_IO {
            idc = IDC_BODY_LEFTARM_PRESSURECUFF;
            text = QPATHTOF(data\body_image\leftarm_aed_pressurecuff.paa);
        };
        class ArmLeftT: Background {
            text = QPATHTOF(data\body_image\leftarm_tourniquet.paa);
        };
        class ArmRightT: ArmLeftT {
            text = QPATHTOF(data\body_image\rightarm_tourniquet.paa);
        };
        class LegLeftT: ArmLeftT {};
        class LegRightT: ArmLeftT {};
    };
};

class ACE_Medical_Menu {
    class Controls {
        class BodyLabelLeft: RscText {
            idc = IDC_SIDE_LABEL_LEFT;
            show = 0;
        };
        class BodyLabelRight: BodyLabelLeft {
            idc = IDC_SIDE_LABEL_RIGHT;
            show = 0;
        };
    };
};

class ACEGVAR(medical_gui,TriageSelect): RscControlsGroupNoScrollbars {
    class Controls {
        class None: RscButton {};
        class Deceased: None {
            text = CSTRING(Triage_Priority4);
        };
    };
};

class ACE_Medical_Menu_ActionButton;
class ACM_MedicalMenu_ActionButton_None: ACE_Medical_Menu_ActionButton {
    class ShortcutPos
    {
        left = 0.01;
        top = 0;
        w = QUOTE(POS_W(1));
        h = QUOTE(POS_H(1));
    };
};

#include "ActionButtons.hpp"