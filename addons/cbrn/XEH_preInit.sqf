#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY LLSTRING(Category)

// Basic

[
    QGVAR(enable),
    "CHECKBOX",
    [LLSTRING(SETTING_Enable), LLSTRING(SETTING_Enable_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [true], // TODO
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Chemical_CS_Blindness),
    "CHECKBOX",
    [LLSTRING(SETTING_Chemical_CS_Blindness), LLSTRING(SETTING_Chemical_CS_Blindness_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_CS)],
    [true], // TODO
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Chemical_Chlorine_Blindness),
    "CHECKBOX",
    [LLSTRING(SETTING_Chemical_Chlorine_Blindness), LLSTRING(SETTING_Chemical_Chlorine_Blindness_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_Chlorine)],
    [true], // TODO
    true
] call CBA_fnc_addSetting;

ADDON = true;