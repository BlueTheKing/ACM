#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define AMS_SETTINGS_CATEGORY "AMS: Core"

//ACEGVAR(medical,STATE_MACHINE) = (configFile >> "AMS_StateMachine") call CBA_statemachine_fnc_createFromConfig; // TODO statemachine fuckery

[
    QGVAR(treatmentTimeTakeOffTourniquet),
    "SLIDER",
    "Take Off Tourniquet Time",
    [AMS_SETTINGS_CATEGORY, ""],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;

ADDON = true;