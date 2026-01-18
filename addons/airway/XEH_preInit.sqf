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
    [LSTRING(SETTING_Enable), LSTRING(SETTING_Enable_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayCollapseChance),
    "SLIDER",
    LSTRING(SETTING_AirwayCollapseChance),
    [ACM_SETTINGS_CATEGORY, ""],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayObstructionBloodChance),
    "SLIDER",
    LSTRING(SETTING_AirwayObstructionChance_Blood),
    [ACM_SETTINGS_CATEGORY, ""],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayObstructionVomitChance),
    "SLIDER",
    LSTRING(SETTING_AirwayObstructionChance_Vomit),
    [ACM_SETTINGS_CATEGORY, ""],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

// Airway Management

[
    QGVAR(treatmentTimeRecoveryPosition),
    "SLIDER",
    [LSTRING(SETTING_TreatmentTime_RecoveryPosition), LSTRING(SETTING_TreatmentTime_RecoveryPosition_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayManagement)],
    [1, 30, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowSuctionBag),
    "LIST",
    [LSTRING(SETTING_Allow_SuctionBag), LSTRING(SETTING_Allow_SuctionBag_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayManagement)],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowACCUVAC),
    "LIST",
    [LSTRING(SETTING_Allow_ACCUVAC), LSTRING(SETTING_Allow_ACCUVAC_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayManagement)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

// Surgical Airway

[
    QGVAR(allowSurgicalAirway),
    "LIST",
    [LSTRING(SETTING_Allow_SurgicalAirway), LSTRING(SETTING_Allow_SurgicalAirway_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayManagement)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

// Airway Adjunct

[
    QGVAR(treatmentTimeOPA),
    "SLIDER",
    [LSTRING(SETTING_TreatmentTime_OPA), LSTRING(SETTING_TreatmentTime_OPA_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayAdjunct)],
    [1, 30, 3, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeNPA),
    "SLIDER",
    [LSTRING(SETTING_TreatmentTime_NPA), LSTRING(SETTING_TreatmentTime_NPA_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayAdjunct)],
    [1, 30, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeSGA),
    "SLIDER",
    [LSTRING(SETTING_TreatmentTime_SGA), LSTRING(SETTING_TreatmentTime_SGA_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayAdjunct)],
    [1, 30, 7, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowOPA),
    "LIST",
    [LSTRING(SETTING_Allow_OPA), LSTRING(SETTING_Allow_OPA_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayAdjunct)],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowNPA),
    "LIST",
    [LSTRING(SETTING_Allow_NPA), LSTRING(SETTING_Allow_NPA_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayAdjunct)],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowSGA),
    "LIST",
    [LSTRING(SETTING_Allow_SGA), LSTRING(SETTING_Allow_SGA_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AirwayAdjunct)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

ADDON = true;
