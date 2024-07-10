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
            "ACM_core"
        };
        author = AUTHOR;
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgMagazines.hpp"
#include "CfgMoves.hpp"
#include "CfgWeapons.hpp"
#include "ACE_Medical_Treatment_Actions.hpp"
#include "\x\ACM\addons\core\UI_defines.hpp"
#include "Defibrillator_Monitor_Dialog.hpp"
#include "RscFeelPulse.hpp"
#include "MeasureBP_Dialog.hpp"
#include "SyringeDraw_Dialog.hpp"
#include "TransfusionMenu_Dialog.hpp"