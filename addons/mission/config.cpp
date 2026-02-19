#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main",
            "ace_main",
            "ace_medical_treatment",
            "ACM_main"
        };
        author = AUTHOR;
        VERSION_CONFIG;
    };
};

#include "CfgVehicles.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgEventHandlers.hpp"
#include "RscDisplayMain.hpp"

class CfgMissions {
    class Missions
    {
        class ACM_TestZone
        {
            directory = "x\ACM\addons\mission\ACM_TestZone.VR";
            overviewPicture = "x\ACM\addons\main\logo.paa";
            overviewText = "#1 Malpractice Simulator™";
        };
    };
    class MPMissions
    {
        class ACM_TestZone
        {
            directory = "x\ACM\addons\mission\ACM_TestZone.VR";
            overviewPicture = "x\ACM\addons\main\logo.paa";
            overviewText = "#1 Malpractice Simulator™";
        };
    };
};