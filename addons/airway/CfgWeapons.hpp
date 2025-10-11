class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACM_OPA: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\opa_ca.paa);
        displayName = CSTRING(OPA);
        descriptionShort = CSTRING(OPA_Desc);
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class ACM_IGel: ACM_OPA {
        picture = QPATHTOF(ui\igel_ca.paa);
        displayName = CSTRING(IGel);
        descriptionShort = CSTRING(IGel_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };

    class ACM_NPA: ACM_OPA {
        picture = QPATHTOF(ui\npa_ca.paa);
        displayName = CSTRING(NPA);
        descriptionShort = CSTRING(NPA_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1.4;
        };
    };

    class ACM_SuctionBag: ACM_OPA {
        picture = QPATHTOF(ui\suctionbag_ca.paa);
        displayName = CSTRING(SuctionBag);
        descriptionShort = CSTRING(SuctionBag_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };

    class ACM_ACCUVAC: ACM_SuctionBag {
        picture = QPATHTOF(ui\accuvac_ca.paa);
        displayName = CSTRING(ACCUVAC);
        descriptionShort = CSTRING(ACCUVAC_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 20;
        };
    };

    class ACM_CricKit: ACM_OPA {
        picture = QPATHTOF(ui\crickit_ca.paa);
        displayName = CSTRING(CricKit);
        descriptionShort = CSTRING(CricKit_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2.5;
        };
    };
};