class SmokeShellWhite;

#define SMOKESHELL_ENTRY(classname) \
    class SmokeShellWhite: SmokeShellWhite { \
        simulation = "particles"; \
        type = QUOTE(ACM_Mortar_Shell_##classname##_Effect); \
        position[] = {0,0,0}; \
        intensity = 1; \
        interval = 1; \
    } \

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
    class ACM_ChemicalDevice_Sarin: ACM_ChemicalDevice_Chlorine {
        color[] =
        {
            {0.8,0.8,0.8,0.01},
            {0.8,0.8,0.8,0.0025},
            {0.8,0.8,0.8,0.0009},
            {0.8,0.8,0.8,0.0001}
        };
    };
    class ACM_ChemicalDevice_Sarin_Small: ACM_ChemicalDevice_Sarin {
        lifeTime = 20;
        size[] = {0.7,1.2};
        circleRadius = 0.1;
    };
    class ACM_ChemicalDevice_Lewisite: ACM_ChemicalDevice_Sarin {};
    class ACM_ChemicalDevice_Lewisite_Small: ACM_ChemicalDevice_Sarin_Small {};

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
    class ACM_Mortar_Shell_Sarin_Effect: ACM_Mortar_Shell_CS_Effect {
        color[] =
        {
            {0.8,0.8,0.8,0.015},
            {0.8,0.8,0.8,0.001},
            {0.8,0.8,0.8,0}
        };
    };
    class ACM_Mortar_Shell_Lewisite_Effect: ACM_Mortar_Shell_Sarin_Effect {};
};

class SmokeShellWhiteSmall;
class ACM_Mortar_Shell_CS_Effect: SmokeShellWhiteSmall {
    SMOKESHELL_ENTRY(CS);
};

class ACM_Mortar_Shell_Chlorine_Effect: ACM_Mortar_Shell_CS_Effect {
    SMOKESHELL_ENTRY(Chlorine);
};

class ACM_Mortar_Shell_Sarin_Effect: ACM_Mortar_Shell_CS_Effect {
    SMOKESHELL_ENTRY(Sarin);
};

class ACM_Mortar_Shell_Lewisite_Effect: ACM_Mortar_Shell_CS_Effect {
    SMOKESHELL_ENTRY(Lewisite);
};