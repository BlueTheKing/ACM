#define MORTAR_SHELL_EFFECT_ENTRY(x) \
    class ACM_Mortar_Shell_##x##_Smoke: ACM_Mortar_Shell_CS_Smoke { \
        effectsSmoke = QUOTE(ACM_Mortar_Shell_##x##_Effect); \
    } \

#define MORTAR_SHELL_ENTRY(x,ttl) \
    class ACM_Mortar_Shell_##x##_A: Smoke_82mm_AMOS_White { \
        timeToLive = ttl; \
        submunitionAmmo = QUOTE(ACM_Mortar_Shell_##x##_Smoke); \
    } \

class CfgAmmo {
    class SmokeShell;
    class ACM_Grenade_CS_A: SmokeShell {
        timeToLive = 40;
        smokeColor[] = {1,1,1,0.15};
        cost = 1000;
        aiAmmoUsageFlags = "64";
        model = QPATHTOF(model\grenade_cs_throw.p3d);
    };

    class G_40mm_Smoke;
    class ACM_Grenade_Shell_CS_A: G_40mm_Smoke {
        timeToLive = 40;
        smokeColor[] = {1,1,1,0.15};
        cost = 1000;
        aiAmmoUsageFlags = "64";
    };

    class SmokeShellArty;
    class ACM_Mortar_Shell_CS_Smoke: SmokeShellArty {
        effectsSmoke = "ACM_Mortar_Shell_CS_Effect";
    };
    MORTAR_SHELL_EFFECT_ENTRY(Chlorine);
    MORTAR_SHELL_EFFECT_ENTRY(Sarin);
    MORTAR_SHELL_EFFECT_ENTRY(Lewisite);

    class Smoke_82mm_AMOS_White;
    class ACM_Mortar_Shell_CS_A: Smoke_82mm_AMOS_White {
        timeToLive = 50;
        submunitionAmmo = "ACM_Mortar_Shell_CS_Smoke";
    };
    MORTAR_SHELL_ENTRY(Chlorine,50);
    MORTAR_SHELL_ENTRY(Sarin,30);
    MORTAR_SHELL_ENTRY(Lewisite,30);
};