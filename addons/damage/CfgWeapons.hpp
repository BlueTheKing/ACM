class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACM_PressureBandage: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        model = QACEPATHTOF(medical_treatment,data\bandage.p3d);
        picture = QPATHTOF(ui\pressurebandage.paa);
        displayName = "Pressure Bandage";
        descriptionShort = "Standard issue bandage";
        descriptionUse = "Versatile emergency bandage with built-in pressure bar to effectively control bleeding";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.6;
        };
    };
    class ACM_EmergencyTraumaDressing: ACM_PressureBandage {
        picture = QPATHTOF(ui\etd.paa);
        displayName = "Emergency Trauma Dressing";
        descriptionShort = "Trauma dressing with large surface area";
        descriptionUse = "Dressing with oversized pad, designed to stem bleeding of large pattern wounds, and traumatic amputations";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };
    class ACM_ElasticWrap: ACM_PressureBandage {
        picture = QACEPATHTOF(medical_treatment,ui\elasticbandage_ca.paa);
        displayName = "Elastic Wrap";
        descriptionShort = "Used to wrap bandages and bruises";
        descriptionUse = "Flexible wrap used to support and put pressure on bandaged wounds, compress and treat bruises, and stabilize splints";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.3;
        };
    };
    /*class ACM_chitosanInjector: ACE_ItemCore {
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