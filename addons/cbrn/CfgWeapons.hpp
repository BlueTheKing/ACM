class CfgWeapons {
	class GrenadeLauncher;
    class Throw: GrenadeLauncher {
        muzzles[] += {"ACM_Grenade_CS_Muzzle"};

        class ThrowMuzzle;
        class ACM_Grenade_CS_Muzzle: ThrowMuzzle {
            magazines[] = {"ACM_Grenade_CS"};
        };
    };
};