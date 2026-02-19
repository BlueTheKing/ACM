class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACM_ChestSeal: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\chestseal_ca.paa);
        displayName = CSTRING(ChestSeal);
        descriptionShort = CSTRING(ChestSeal_Desc);
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };

    class ACM_PulseOximeter: ACM_ChestSeal {
        picture = QPATHTOF(ui\pulseoximeter_ca.paa);
        displayName = CSTRING(PulseOximeter);
        descriptionShort = CSTRING(PulseOximeter_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class ACM_Stethoscope: ACM_ChestSeal {
        picture = QPATHTOF(ui\stethoscope_ca.paa);
        displayName = CSTRING(Stethoscope);
        descriptionShort = CSTRING(Stethoscope_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2;
        };
    };

    class ACM_NCDKit: ACM_ChestSeal {
        picture = QPATHTOF(ui\ncdkit_ca.paa);
        displayName = CSTRING(NCDKit);
        descriptionShort = CSTRING(NCDKit_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class ACM_ChestTubeKit: ACM_ChestSeal {
        picture = QPATHTOF(ui\chestTubeKit_ca.paa);
        displayName = CSTRING(ChestTubeKit);
        descriptionShort = CSTRING(ChestTubeKit_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 4;
        };
    };

    class ACM_ThoracostomyKit: ACM_ChestSeal {
        picture = QPATHTOF(ui\thoracostomyKit_ca.paa);
        displayName = CSTRING(ThoracostomyKit);
        descriptionShort = CSTRING(ThoracostomyKit_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 4;
        };
    };

    class ACM_PocketBVM: ACM_ChestSeal {
        picture = QPATHTOF(ui\pocketbvm_ca.paa);
        displayName = CSTRING(PocketBVM);
        descriptionShort = CSTRING(PocketBVM_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 5;
        };
    };

    /*class ACM_PocketBVM_Packed: ACM_PocketBVM {
        picture = QPATHTOF(ui\pocketbvm_p_ca.paa);
        displayName = "Pocket BVM (Packaged)";
        descriptionShort = "desc short";
        descriptionUse = "desc use";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 2.5;
        };
    };*/

    class ACM_BVM: ACM_PocketBVM {
        picture = QPATHTOF(ui\bvm_ca.paa);
        displayName = CSTRING(BVM);
        descriptionShort = CSTRING(BVM_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 12;
        };
    };

    class ACM_OxygenTank_425_Empty: ACM_ChestSeal {
        scope = 1;
        picture = QPATHTOF(ui\oxygenTank_ca.paa);
        displayName = CSTRING(OxygenTank_425_Empty);
        descriptionShort = CSTRING(OxygenTank_425_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 20;
        };
    };
};