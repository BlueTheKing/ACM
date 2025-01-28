class CfgCloudlets {
    class SmokeShellWhiteSmall;
    class ACM_Mortar_Shell_CS_Effect: SmokeShellWhiteSmall {
        lifeTime = 20;
        weight = 1.3;
        //size[] = {0.1, 5, 8};
        position[] = {0,0.4,0};
        color[] =
        {
			{0.8,0.8,0.8,0.2},
			{0.8,0.8,0.8,0.1},
			{0.8,0.8,0.8,0}
		};
        rotationVelocityVar = 12;
        moveVelocity[] = {0, 0.05, 0};
        moveVelocityVar[] = {0.5, 0.1, 0.5};
    };
};

class SmokeShellWhiteSmall;
class ACM_Mortar_Shell_CS_Effect: SmokeShellWhiteSmall
{
    class SmokeShellWhite: SmokeShellWhite
    {
        simulation = "particles";
        type = "ACM_Mortar_Shell_CS_Effect";
        position[] = {0,0,0};
        intensity = 1;
        interval = 1;
    };
};