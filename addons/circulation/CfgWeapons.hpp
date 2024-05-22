class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACM_AED: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\AED_ca.paa);
        displayName = "Automated External Defibrillator";
        descriptionShort = "Device used to treat cardiac arrest";
        descriptionUse = "Battery-powered device used to treat shockable cardiac arrest rhythms and measure other vitals";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 40;
        };
    };

    class ACM_PressureCuff: ACM_AED {
        picture = QPATHTOF(ui\pressureCuff_ca.paa);
        displayName = "Pressure Cuff";
        descriptionShort = "Used to measure blood pressure";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };

    class ACM_IV_16g: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\IV_16g_ca.paa);
        displayName = "16g IV";
        descriptionShort = "Used to transfuse fluids in case of blood loss";
        descriptionUse = "Medical device used to gain vein access to transfuse fluids or medication in patients";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };

    class ACM_IV_14g: ACM_IV_16g {
        picture = QPATHTOF(ui\IV_14g_ca.paa);
        displayName = "14g IV";
        descriptionShort = "Used to rapidly transfuse fluids in case of blood loss";
        descriptionUse = "Medical device used to gain vein access to transfuse fluids or medication in patients, due to the larger diameter it allows for higher flow rates";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.5;
        };
    };

    class ACM_IO_FAST: ACM_IV_16g {
        picture = QPATHTOF(ui\IO_FAST1_ca.paa);
        displayName = "FAST1 IO";
        descriptionShort = "Used to transfuse fluids in case of severe injury";
        descriptionUse = "Needle used to rapidly gain intraosseus access through the sternum to deliver fluids or medication to critical patients";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.3;
        };
    };

    class ACM_Vial_Epinephrine: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\vial_epinephrine_ca.paa);
        displayName = "Epinephrine Vial";
        descriptionShort = ACECSTRING(medical_treatment,Epinephrine_Desc_Short);
        descriptionUse = ACECSTRING(medical_treatment,Epinephrine_Desc_Use);
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };
    class ACM_Vial_Adenosine: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_adenosine_ca.paa);
        displayName = "Adenosine Vial";
        descriptionShort = ACECSTRING(medical_treatment,adenosine_Desc_Short);
        descriptionUse = ACECSTRING(medical_treatment,adenosine_Desc_Use);
    };
    class ACM_Vial_Morphine: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_morphine_ca.paa);
        displayName = "Morphine Vial";
        descriptionShort = ACECSTRING(medical_treatment,Morphine_Desc_Short);
        descriptionUse = ACECSTRING(medical_treatment,Morphine_Desc_Use);
    };
    class ACM_Vial_TXA: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_txa_ca.paa);
        displayName = "TXA Vial";
        descriptionShort = "Used to manage catastrophic bleeding by improving clotting ability";
        descriptionUse = "Medication used to manage catastrophic bleeding by impeding the breakdown of clots, improving clotting ability";
    };

    class ACM_Vial_Amiodarone: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\vial_amiodarone_ca.paa);
        displayName = "Amiodarone Vial";
        descriptionShort = "Used to treat irregular heart rhythms";
        descriptionUse = "Medication used to treat irregular heart rhythms like VF/VT by affecting the electrical signals of the heart";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };

    class ACM_Spray_Naloxone: ACM_Vial_Epinephrine {
        picture = QPATHTOF(ui\spray_naloxone_ca.paa);
        displayName = "Naloxone Nasal Spray";
        descriptionShort = "Used to rapidly reverse opioid overdose";
        descriptionUse = "Nasal spray used to temporarily reverse opioid overdose";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.2;
        };
    };

    #include "CfgWeapons_Blood.hpp"
};