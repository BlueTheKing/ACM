class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACE_splint: ACE_ItemCore {
        displayName = CSTRING(UniversalSplint);
        descriptionShort = CSTRING(UniversalSplint_Desc);
    };
    class ACM_SAMSplint: ACE_splint {
        author = "Blue";
        picture = QPATHTOF(ui\samSplint.paa);
        displayName = CSTRING(SAMSplint);
        descriptionShort = CSTRING(SAMSplint_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.5;
        };
    };
};