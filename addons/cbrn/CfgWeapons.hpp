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
        magazines[] += {"ACM_Mortar_Shell_8Rnd_CS"};
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
};