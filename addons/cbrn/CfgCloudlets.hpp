class CfgCloudlets {
    class BombSmk2;
    class ACM_ChemicalDevice_Chlorine: BombSmk2 {
        lifeTime = 30;
        circleRadius = 1;
        particleFSNtieth = 16;
        particleFSIndex = 12;
        particleFSFrameCount = 8;
        particleFSLoop = 0;
        weight = 1.4;
        rubbing = 1.1;
        size[] = {3,5};
        color[] =
        {
            {0.6,0.63,0,0.4},
            {0.6,0.63,0,0.22},
            {0.5,0.53,0,0.09},
            {0.5,0.53,0,0.01}
        };
        animationSpeed[]={1,0.5,0.25,0.25};
        colorVar[] = {0,0,0,0};
    };
    class ACM_ChemicalDevice_Chlorine_Small: ACM_ChemicalDevice_Chlorine {
        lifeTime = 20;
        size[] = {0.7,1.2};
        circleRadius = 0.1;
    };

    class SmokeShellWhiteSmall;
    class ACM_Mortar_Shell_CS_Effect: SmokeShellWhiteSmall {
        lifeTime = 20;
        weight = 1.3;
        position[] = {0,0.2,0};
        color[] =
        {
            {0.8,0.8,0.8,0.2},
            {0.8,0.8,0.8,0.1},
            {0.8,0.8,0.8,0}
        };
        rotationVelocityVar = 12;
        moveVelocity[] = {0,0.05,0};
        moveVelocityVar[] = {0.5,0.1,0.5};
    };
    class ACM_Mortar_Shell_Chlorine_Effect: ACM_Mortar_Shell_CS_Effect {
        color[] =
        {
            {0.6,0.63,0,0.4},
            {0.6,0.63,0,0.25},
            {0.6,0.63,0,0}
        };
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

class ACM_Mortar_Shell_Chlorine_Effect: ACM_Mortar_Shell_CS_Effect
{
    class SmokeShellWhite: SmokeShellWhite
    {
        simulation = "particles";
        type = "ACM_Mortar_Shell_Chlorine_Effect";
        position[] = {0,0,0};
        intensity = 1;
        interval = 1;
    };
};