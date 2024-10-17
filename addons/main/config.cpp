#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main",
            "ace_main"
        };
        author = AUTHOR;
		url="https://discord.gg/5MNPpBpsEr/";
        VERSION_CONFIG;
    };
};

#include "CfgSettings.hpp"