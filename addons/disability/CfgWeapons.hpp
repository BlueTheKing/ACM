class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;
    class ACE_ItemCore;

    class ACE_splint: ACE_ItemCore {
        displayName = "Universal Splint";
        descriptionShort = "Single-use splint kit used to immobilize fracture";
    };
    class ACM_SAMSplint: ACE_splint {
        author = "Blue";
        picture = QPATHTOF(ui\samSplint.paa);
        displayName = "SAM Splint";
        descriptionShort = "Multi-use splint made of malleable aluminium, should be wrapped to keep fracture stable";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.5;
        };
    };
};