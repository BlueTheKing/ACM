class CfgWeapons {
    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACM_ChestSeal: ACE_ItemCore {
        scope = 2;
        author = "Blue";
        picture = QPATHTOF(ui\chestseal_ca.paa);
        displayName = "Chest Seal";
        descriptionShort = "Used to manage penetrating chest injuries";
        descriptionUse = "Adhesive dressing used to stop air from entering the penetrating injury, keeping lung function and preventing deterioration";
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class ACM_PulseOximeter: ACM_ChestSeal {
        picture = QPATHTOF(ui\pulseoximeter_ca.paa);
        displayName = "Pulse Oximeter";
        descriptionShort = "Used to measure patient vitals";
        descriptionUse = "Small device used to measure patient oxygen saturation and pulse rate";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class ACM_Stethoscope: ACM_ChestSeal {
        picture = QPATHTOF(ui\stethoscope_ca.paa);
        displayName = "Stethoscope";
        descriptionShort = "Used to listen to breathing and heart sounds of patient";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1.5;
        };
    };

    class ACM_NCDKit: ACM_ChestSeal {
        picture = QPATHTOF(ui\ncdkit_ca.paa);
        displayName = "NCD Kit";
        descriptionShort = "Single-use needle used to decompress tension-pneumothorax";
        descriptionUse = "Single-use needle used to decompress tension-pneumothorax by creating a deep hole in the side of the patient's chest";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class ACM_PocketBVM: ACM_ChestSeal {
        picture = QPATHTOF(ui\pocketbvm_ca.paa);
        displayName = "Pocket BVM";
        descriptionShort = "Compact version of Bag-Valve-Mask";
        descriptionUse = "Compact variant of Bag-Valve-Mask, device used to ventilate non-breathing patient by inflating and deflating the lungs with air";
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
        displayName = "Bag-Valve-Mask";
        descriptionShort = "Used to ventilate patient that is not breathing";
        descriptionUse = "Device used to ventilate non-breathing patient by inflating and deflating the lungs with air, may be connected to oxygen";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 5;
        };
    };
};