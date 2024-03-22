class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class AMS_IV_16g: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\IV_16g_ca.paa);
        displayName = "16g IV";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };

    class AMS_IV_14g: AMS_IV_16g {
        picture = QPATHTOF(ui\IV_14g_ca.paa);
        displayName = "14g IV";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.5;
        };
    };

    class AMS_IO_FAST1: AMS_IV_16g {
        picture = QPATHTOF(ui\IO_FAST1_ca.paa);
        displayName = "FAST1 IO";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.3;
        };
    };

    class AMS_Vial_Epinephrine: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\vial_epinephrine_ca.paa);
        displayName = "Epinephrine Vial";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };
    class AMS_Vial_Adenosine: AMS_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_adenosine_ca.paa);
        displayName = "Adenosine Vial";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
    };
    class AMS_Vial_Morphine: AMS_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_morphine_ca.paa);
        displayName = "Morphine Vial";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
    };
    class AMS_Vial_TXA: AMS_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_txa_ca.paa);
        displayName = "TXA Vial";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
    };

    class AMS_Vial_Amiodarone: AMS_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_amiodarone_ca.paa);
        displayName = "Amiodarone Vial";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };

    class AMS_Paracetamol: AMS_Vial_Epinephrine {
        picture = QPATHTOF(ui\paracetamol_ca.paa);
        displayName = "Paracetamol";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.3;
        };
    };

    class AMS_AmmoniumCarbonate: AMS_Paracetamol {
        picture = QPATHTOF(ui\ammoniumcarbonate_ca.paa);
        displayName = "Ammonium Carbonate";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
    };

    class AMS_Inhaler_Penthrox: AMS_Paracetamol {
        picture = QPATHTOF(ui\inhaler_penthrox_ca.paa);
        displayName = "Penthrox Inhaler";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
    };

    class AMS_Spray_Naloxone: AMS_Paracetamol {
        picture = QPATHTOF(ui\spray_naloxone_ca.paa);
        displayName = "Naloxone Nasal Spray";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };
};