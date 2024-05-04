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

#include "CfgEventHandlers.hpp"
#include "RscDisplayMain.hpp"