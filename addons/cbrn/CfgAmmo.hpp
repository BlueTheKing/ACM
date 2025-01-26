class CfgAmmo {
    class SmokeShell;
    class ACM_Grenade_CS_A: SmokeShell
    {
        
        timeToLive = 40;
        smokeColor[] = {1,1,1,0.2};
        cost = 1000;
        aiAmmoUsageFlags = "64";
    };

    class G_40mm_Smoke;
    class ACM_Grenade_Shell_CS_A: G_40mm_Smoke
    {
        timeToLive = 40;
        smokeColor[] = {1,1,1,0.2};
        cost = 1000;
        aiAmmoUsageFlags = "64";
    };
};