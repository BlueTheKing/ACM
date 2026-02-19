#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {"ACM_MedicalSupplyCrate_Basic", "ACM_MedicalSupplyCrate_Advanced"};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main",
            "ace_main",
            "ace_medical_treatment",
            "ace_medical_statemachine"
        };
        author = AUTHOR;
        VERSION_CONFIG;
    };
};

#include "ACM_Statemachine.hpp"
#include "CfgEditorSubcategories.hpp"
#include "CfgFunctions.hpp"
#include "CfgEventHandlers.hpp"
#include "ACE_Medical_Treatment.hpp"
#include "ACM_Medication.hpp"
#include "ACE_Medical_Treatment_Actions.hpp"
#include "CfgMoves.hpp"
#include "CfgSounds.hpp"
#include "CfgReplacementItems.hpp"
#include "CfgVehicles.hpp"

#include "UI_defines.hpp"
#include "RscTitles.hpp"