class CfgMagazines {
    class SmokeShell;
    class ACM_Grenade_CS: SmokeShell
    {
        author = AUTHOR;
        displayName = CSTRING(CS_Grenade);
        displayNameShort = CSTRING(CS_Grenade);
        picture = QPATHTOF(ui\grenade_cs_ca.paa);
        model = "\A3\Weapons_f\ammo\smokegrenade_purple";
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
        mass  =  4;
    };
};