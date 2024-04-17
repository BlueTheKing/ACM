class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACM_GuedelTube: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\guedeltube_ca.paa);
        displayName = "Guedel Tube";
        descriptionShort = "Used to keep airway open";
        descriptionUse = "An airway adjunct used to mitigate airway collapse and allow breathing in unconscious patients.";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class ACM_GuedelTube_Used: ACM_GuedelTube {
        displayName = "Guedel Tube (Used)";
        descriptionShort = "Already used? ew";
    };

    class ACM_IGel: ACM_GuedelTube {
        picture = QPATHTOF(ui\igel_ca.paa);
        displayName = "i-Gel";
        descriptionShort = "Used to secure airway for prolonged time";
        descriptionUse = "An airway adjunct used to secure the airway and allow breathing in unconscious patients for a prolonged time.";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };

    class ACM_IGel_Used: ACM_IGel {
        displayName = "i-Gel (Used)";
        descriptionShort = "Already used? ew";
    };

    class ACM_SuctionBag: ACM_GuedelTube {
        picture = QPATHTOF(ui\suctionbag_ca.paa);
        displayName = "Emergency Disposable Suction Bag";
        descriptionShort = "Single-use bag used to clear airway obstructions";
        descriptionUse = "Portable single-use bag used to clear airway obstructions and allow effective breathing.";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 4;
        };
    };

    class ACM_ACCUVAC: ACM_SuctionBag {
        picture = QPATHTOF(ui\accuvac_ca.paa);
        displayName = "ACCUVAC";
        descriptionShort = "Device used to clear airway obstruction";
        descriptionUse = "Battery-powered suction device used to swiftly clear obstructions and allow effective breathing.";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 20;
        };
    };
};