class CfgMagazines {
    class SmokeShell;
    class ACM_Grenade_CS: SmokeShell
    {
        author = AUTHOR;
        displayName = CSTRING(CS_Grenade);
        displayNameShort = CSTRING(CS_Grenade);
        picture = QPATHTOF(ui\grenade_cs_ca.paa);
        model = QPATHTOF(model\grenade_cs.p3d);
        ammo = "ACM_Grenade_CS_A";
        descriptionShort = CSTRING(CS_Grenade_Desc);
        mass = 4;
    };

    class 1Rnd_Smoke_Grenade_shell;
    class ACM_Grenade_Shell_CS: 1Rnd_Smoke_Grenade_shell
    {
        author = AUTHOR;
        displayName = CSTRING(CS_Shell_40mm);
        displayNameShort = CSTRING(CS_Shell_40mm);
        picture = QPATHTOF(ui\40mm_cs_ca.paa);
        ammo = "ACM_Grenade_Shell_CS_A";
        descriptionShort = CSTRING(CS_Shell_40mm_Desc);
        mass = 4;
    };

    class 8Rnd_82mm_Mo_Smoke_white;
    class ACM_Mortar_Shell_8Rnd_CS: 8Rnd_82mm_Mo_Smoke_white
    {
        author = AUTHOR;
        displayName = CSTRING(CS_Shell_82mm);
        displayNameShort = CSTRING(CS_Shell_82mm);
        ammo = "ACM_Mortar_Shell_CS_A";
    };
    class ACM_Mortar_Shell_8Rnd_Chlorine: ACM_Mortar_Shell_8Rnd_CS
    {
        author = AUTHOR;
        displayName = CSTRING(Chlorine_Shell_82mm);
        displayNameShort = CSTRING(Chlorine_Shell_82mm_Short);
        ammo = "ACM_Mortar_Shell_Chlorine_A";
    };
};