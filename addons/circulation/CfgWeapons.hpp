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
};