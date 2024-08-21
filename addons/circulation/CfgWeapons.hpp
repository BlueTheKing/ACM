class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACM_AED: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\AED_ca.paa);
        displayName = CSTRING(AED);
        descriptionShort = CSTRING(AED_Desc);
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 40;
        };
    };

    class ACM_PressureCuff: ACM_AED {
        picture = QPATHTOF(ui\pressureCuff_ca.paa);
        displayName = CSTRING(PressureCuff);
        descriptionShort = CSTRING(PressureCuff_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 4;
        };
    };

    class ACM_IV_16g: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\IV_16g_ca.paa);
        displayName = CSTRING(IV_16g);
        descriptionShort = CSTRING(IV_16g_Desc);
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };

    class ACM_IV_14g: ACM_IV_16g {
        picture = QPATHTOF(ui\IV_14g_ca.paa);
        displayName = CSTRING(IV_14g);
        descriptionShort = CSTRING(IV_14g_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.5;
        };
    };

    class ACM_IO_FAST: ACM_IV_16g {
        picture = QPATHTOF(ui\IO_FAST1_ca.paa);
        displayName = CSTRING(IO_FAST1);
        descriptionShort = CSTRING(IO_FAST1_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.3;
        };
    };

    class ACM_IO_EZ: ACM_IV_16g {
        picture = QPATHTOF(ui\IO_EZ_ca.paa);
        displayName = CSTRING(IO_EZ);
        descriptionShort = CSTRING(IO_EZ_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };

    class ACM_Syringe_10: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\syringe_10_ca.paa);
        displayName = "Syringe (10ml)";
        descriptionShort = "Used to administer 10ml of medication";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.9;
        };
    };
    class ACM_Syringe_5: ACM_Syringe_10 {
        picture = QPATHTOF(ui\syringe_5_ca.paa);
        displayName = "Syringe (5ml)";
        descriptionShort = "Used to administer 5ml of medication";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.7;
        };
    };
    class ACM_Syringe_3: ACM_Syringe_10 {
        picture = QPATHTOF(ui\syringe_3_ca.paa);
        displayName = "Syringe (3ml)";
        descriptionShort = "Used to administer 3ml of medication";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.6;
        };
    };
    class ACM_Syringe_1: ACM_Syringe_10 {
        picture = QPATHTOF(ui\syringe_1_ca.paa);
        displayName = "Syringe (1ml)";
        descriptionShort = "Used to administer 1ml of medication";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.5;
        };
    };

    class ACM_Syringe_IM: ACE_ItemCore {
        scope = 0;
        author = "Blue";
        picture = QPATHTOF(ui\syringe_im_ca.paa);
        displayName = CSTRING(Syringe_IM);
        descriptionShort = "";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.8;
        };
    };
    class ACM_Syringe_IV: ACM_Syringe_IM {
        picture = QPATHTOF(ui\syringe_iv_ca.paa);
        displayName = CSTRING(Syringe_IV);
        descriptionShort = "";
    };

    class ACM_Vial_Epinephrine: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\vial_epinephrine_ca.paa);
        displayName = CSTRING(Vial_Epinephrine);
        descriptionShort = CSTRING(Vial_Epinephrine_Desc);
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
        ACM_isVial = 1;
    };
    class ACM_Vial_Adenosine: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_adenosine_ca.paa);
        displayName = CSTRING(Vial_Adenosine);
        descriptionShort = CSTRING(Vial_Adenosine_Desc);
    };
    class ACM_Vial_Morphine: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_morphine_ca.paa);
        displayName = CSTRING(Vial_Morphine);
        descriptionShort = CSTRING(Vial_Morphine_Desc);
    };
    class ACM_Vial_Ketamine: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_ketamine_ca.paa);
        displayName = CSTRING(Vial_Ketamine);
        descriptionShort = CSTRING(Vial_Ketamine_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };

    class ACM_Vial_Lidocaine: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_lidocaine_ca.paa);
        displayName = CSTRING(Vial_Lidocaine);
        descriptionShort = CSTRING(Vial_Lidocaine_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };

    class ACM_Vial_TXA: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_txa_ca.paa);
        displayName = CSTRING(Vial_TXA);
        descriptionShort = CSTRING(Vial_TXA_Desc);
    };
    class ACM_Vial_Amiodarone: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_amiodarone_ca.paa);
        displayName = CSTRING(Vial_Amiodarone);
        descriptionShort = CSTRING(Vial_Amiodarone_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };
    
    class ACM_Spray_Naloxone: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\spray_naloxone_ca.paa);
        displayName = CSTRING(Spray_Naloxone);
        descriptionShort = CSTRING(Spray_Naloxone_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
        ACM_isVial = 0;
    };

    #include "CfgWeapons_Blood.hpp"
};