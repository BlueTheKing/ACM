class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACE_splint: ACE_ItemCore {
        displayName = CSTRING(UniversalSplint);
        descriptionShort = CSTRING(UniversalSplint_Desc);
        scope = 1;
    };
    class ACM_SAMSplint: ACE_splint {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\samSplint.paa);
        displayName = CSTRING(SAMSplint);
        descriptionShort = CSTRING(SAMSplint_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 0.5;
        };
    };
};