#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define CBA_SETTINGS_CATEGORY "AMS: Airway"
    
[
    QGVAR(AAAA),
    "CHECKBOX",
    "Text",
    [CBA_SETTINGS_CATEGORY, "Basic"],
    [true],
    true
] call CBA_Settings_fnc_init;

ADDON = true;
