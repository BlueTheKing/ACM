#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {
            "ACM_HazardObject",
            QGVAR(moduleCreateHazardZone),
            QGVAR(moduleCreateChemicalDevice)
        };
        weapons[] = {
            "ACM_Grenade_CS"
        };
        magazines[] = {
            "ACM_Mortar_Shell_8Rnd_CS",
            "ACM_Mortar_Shell_8Rnd_Chlorine"
        };
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

#include "CfgSounds.hpp"
#include "CfgCloudlets.hpp"
#include "CfgAmmo.hpp"
#include "CfgWeapons.hpp"
#include "CfgMagazines.hpp"
#include "CfgMagazineWells.hpp"
#include "CfgVehicles.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgEventHandlers.hpp"
#include "ACM_CBRN_Hazards.hpp"
#include "RscAttributes.hpp"