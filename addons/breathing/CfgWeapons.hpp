class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class AMS_ChestSeal: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\chestseal_ca.paa);
        displayName = "Chest Seal";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class AMS_PulseOximeter: AMS_ChestSeal {
        picture = QPATHTOF(ui\pulseoximeter_ca.paa);
        displayName = "Pulse Oximeter";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class AMS_Stethoscope: AMS_ChestSeal {
        picture = QPATHTOF(ui\stethoscope_ca.paa);
        displayName = "Stethoscope";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };

    class AMS_NCDKit: AMS_ChestSeal {
        picture = QPATHTOF(ui\ncdkit_ca.paa);
        displayName = "NCD Kit";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class AMS_PocketBVM: AMS_ChestSeal {
        picture = QPATHTOF(ui\pocketbvm_ca.paa);
        displayName = "Pocket BVM";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 5;
        };
    };

    /*class AMS_PocketBVM_Packed: AMS_PocketBVM {
        picture = QPATHTOF(ui\pocketbvm_p_ca.paa);
        displayName = "Pocket BVM (Packaged)";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2.5;
        };
    };*/

    class AMS_BVM: AMS_PocketBVM {
        picture = QPATHTOF(ui\bvm_ca.paa);
        displayName = "Bag-Valve-Mask";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 5;
        };
    };
};