class CfgWeapons {
	class GrenadeLauncher;
    class Throw: GrenadeLauncher {
        muzzles[] += {"ACM_Grenade_CS_Muzzle"};

        class ThrowMuzzle;
        class ACM_Grenade_CS_Muzzle: ThrowMuzzle {
            magazines[] = {"ACM_Grenade_CS"};
        };
    };

    class CannonCore;
    class mortar_82mm: CannonCore {
        magazines[] += {"ACM_Mortar_Shell_8Rnd_CS","ACM_Mortar_Shell_8Rnd_Chlorine","ACM_Mortar_Shell_8Rnd_Sarin","ACM_Mortar_Shell_8Rnd_Lewisite"};
    };

    class ACE_ItemCore;
    class CBA_MiscItem_ItemInfo;

    class ACM_GasMaskFilter: ACE_ItemCore {
        scope = 2;
        author = AUTHOR;
        picture = QPATHTOF(ui\gasMaskFilter_ca.paa);
        displayName = CSTRING(GasMaskFilter);
        descriptionShort = CSTRING(GasMaskFilter_Desc);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 3;
        };
    };

    class ACM_Autoinjector_ATNA: ACE_ItemCore {
        scope = 2;
        author = AUTHOR;
        picture = QPATHTOF(ui\autoinjector_ATNA_ca.paa);
        displayName = CSTRING(Autoinjector_ATNA);
        descriptionShort = CSTRING(Autoinjector_ATNA_Desc);
        ACE_isMedicalItem = 1;
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 1;
        };
    };

    class ACM_Autoinjector_Midazolam: ACM_Autoinjector_ATNA {
        picture = QPATHTOF(ui\autoinjector_midazolam_ca.paa);
        displayName = CSTRING(Autoinjector_Midazolam);
        descriptionShort = CSTRING(Autoinjector_Midazolam_Desc);
    };
};