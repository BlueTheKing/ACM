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
    true,
    {},
    true
] call CBA_fnc_addSetting;

// CS Gas

[
    QGVAR(Chemical_CS_Blindness),
    "CHECKBOX",
    [LLSTRING(SETTING_Chemical_CS_Blindness), LLSTRING(SETTING_Chemical_CS_Blindness_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_CS)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

// Chlorine Gas

[
    QGVAR(Chemical_Chlorine_Blindness),
    "CHECKBOX",
    [LLSTRING(SETTING_Chemical_Chlorine_Blindness), LLSTRING(SETTING_Chemical_Chlorine_Blindness_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_Chlorine)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

// Sarin Gas

[
    QGVAR(Chemical_Sarin_Colorless),
    "CHECKBOX",
    [LLSTRING(SETTING_Chemical_Sarin_Colorless), LLSTRING(SETTING_Chemical_Sarin_Colorless_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_Sarin)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

// Lewisite

[
    QGVAR(Chemical_Lewisite_Blindness),
    "CHECKBOX",
    [LLSTRING(SETTING_Chemical_Lewisite_Blindness), LLSTRING(SETTING_Chemical_Lewisite_Blindness_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_Lewisite)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Chemical_Lewisite_Colorless),
    "CHECKBOX",
    [LLSTRING(SETTING_Chemical_Lewisite_Colorless), LLSTRING(SETTING_Chemical_Lewisite_Colorless_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_Lewisite)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

ADDON = true;