#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define CBA_SETTINGS_CATEGORY "AMS: Core"

//ACEGVAR(medical,STATE_MACHINE) = (configFile >> "AMS_StateMachine") call CBA_statemachine_fnc_createFromConfig; // TODO statemachine fuckery

ADDON = true;