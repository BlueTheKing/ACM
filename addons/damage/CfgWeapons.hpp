class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACM_PressureBandage: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        model = QACEPATHTOF(medical_treatment,data\bandage.p3d);
        picture = QPATHTOF(ui\pressurebandage.paa);
        displayName = CSTRING(PressureBandage);
        descriptionShort = CSTRING(PressureBandage_Desc);
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.6;
        };
    };
    class ACM_EmergencyTraumaDressing: ACM_PressureBandage {
        picture = QPATHTOF(ui\etd.paa);
        displayName = CSTRING(EmergencyTraumaDressing);
        descriptionShort = CSTRING(EmergencyTraumaDressing_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };
    class ACM_ElasticWrap: ACM_PressureBandage {
        picture = QACEPATHTOF(medical_treatment,ui\elasticbandage_ca.paa);
        displayName = CSTRING(ElasticWrap);
        descriptionShort = CSTRING(ElasticWrap_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.3;
        };
    };
};