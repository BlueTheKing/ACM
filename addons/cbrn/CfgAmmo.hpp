class CfgAmmo {
    class SmokeShell;
    class ACM_Grenade_CS_A: SmokeShell
    {
        timeToLive = 40;
        smokeColor[] = {1,1,1,0.2};
        cost = 1000;
        aiAmmoUsageFlags = "64";
        model = QPATHTOF(model\grenade_cs_throw.p3d);
    };

    class G_40mm_Smoke;
    class ACM_Grenade_Shell_CS_A: G_40mm_Smoke
    {
        timeToLive = 40;
        smokeColor[] = {1,1,1,0.2};
        cost = 1000;
        aiAmmoUsageFlags = "64";
    };

    class SmokeShellArty;
    class ACM_Mortar_Shell_CS_Smoke: SmokeShellArty
    {
        effectsSmoke = "ACM_Mortar_Shell_CS_Effect";
    };

    class Smoke_82mm_AMOS_White;
    class ACM_Mortar_Shell_CS_A: Smoke_82mm_AMOS_White
    {
        timeToLive = 50;
        submunitionAmmo = "ACM_Mortar_Shell_CS_Smoke";
    };
};