#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {
            QGVAR(forceWakeUp),
            QGVAR(inflictCardiacArrest),
            QGVAR(inflictChestInjury),
            QGVAR(setBloodVolume),
            QGVAR(unCardiacArrest),
            QGVAR(givePain),
            QGVAR(setOxygen),
            QGVAR(setBloodType),
            QGVAR(togglePlotArmor),
            QGVAR(assignFullHealFacility)
        };
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
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
#include "RscAttributes.hpp"