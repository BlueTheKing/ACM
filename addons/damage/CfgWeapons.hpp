class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class AMS_pressureBandage: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        model = QACEPATHTOF(medical_treatment,data\bandage.p3d);
        picture = QPATHTOF(ui\pressurebandage.paa);
        displayName = "Pressure Bandage";
        descriptionShort = "Standard issue bandage";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.6;
        };
    };
    class AMS_emergencyTraumaDressing: AMS_pressureBandage {
        picture = QPATHTOF(ui\etd.paa);
        displayName = "Emergency Trauma Dressing";
        descriptionShort = "Trauma dressing with large surface area";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };
    class AMS_elasticWrap: AMS_pressureBandage {
        picture = QACEPATHTOF(medical_treatment,ui\elasticbandage_ca.paa);
        displayName = "Elastic Wrap";
        descriptionShort = "Used to wrap bandages and bruises";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.3;
        };
    };
    /*class AMS_chitosanInjector: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        model = QACEPATHTOF(medical_treatment,data\bandage.p3d);
        picture = QPATHTOF(ui\chitosanInjector.paa);
        displayName = "";
        descriptionShort = "";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };*/
};