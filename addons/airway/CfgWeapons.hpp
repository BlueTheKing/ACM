class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class AMS_GuedelTube: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\guedeltube_ca.paa);
        displayName = "Guedel Tube";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class AMS_GuedelTube_Used: AMS_GuedelTube {
        displayName = "Guedel Tube (Used)";
    };

    class AMS_IGel: AMS_GuedelTube {
        picture = QPATHTOF(ui\igel_ca.paa);
        displayName = "i-Gel";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };

    class AMS_IGel_Used: AMS_IGel {
        displayName = "i-Gel (Used)";
    };

    class AMS_SuctionBag: AMS_GuedelTube {
        picture = QPATHTOF(ui\suctionbag_ca.paa);
        displayName = "Emergency Disposable Suction Bag";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 4;
        };
    };

    class AMS_Accuvac: AMS_SuctionBag {
        picture = QPATHTOF(ui\accuvac_ca.paa);
        displayName = "ACCUVAC";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 20;
        };
    };
};