#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define AMS_SETTINGS_CATEGORY "AMS: Airway"

// Basic

[
    QGVAR(enable),
    "CHECKBOX",
    ["Enable Airway", "Enable airway collapse/obstruction"],
    [AMS_SETTINGS_CATEGORY, ""],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayCollapseChance),
    "SLIDER",
    "Airway Collapse Chance Multiplier",
    [AMS_SETTINGS_CATEGORY, ""],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayObstructionBloodChance),
    "SLIDER",
    "Airway Obstruction (Blood) Chance Multiplier",
    [AMS_SETTINGS_CATEGORY, ""],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayObstructionVomitChance),
    "SLIDER",
    "Airway Obstruction (Vomit) Chance Multiplier",
    [AMS_SETTINGS_CATEGORY, ""],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

// Airway Management

[
    QGVAR(treatmentTimeRecoveryPosition),
    "SLIDER",
    ["Establish Recovery Position Time", "Time to establish Recovery Position"],
    [AMS_SETTINGS_CATEGORY, "Airway Management"],
    [1, 30, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowSuctionBag),
    "LIST",
    ["Allow Suction Bag", "Training level required to use Suction Bag"],
    [AMS_SETTINGS_CATEGORY, "Airway Management"],
    [SETTING_SLIDER_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowACCUVAC),
    "LIST",
    ["Allow ACCUVAC", "Training level required to use ACCUVAC"],
    [AMS_SETTINGS_CATEGORY, "Airway Management"],
    [SETTING_SLIDER_SKILL, 1],
    true
] call CBA_fnc_addSetting;

// Airway Adjunct

[
    QGVAR(treatmentTimeOPA),
    "SLIDER",
    ["Guedel Tube Time", "Time to insert Guedel Tube"],
    [AMS_SETTINGS_CATEGORY, "Airway Adjunct"],
    [1, 30, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeSGA),
    "SLIDER",
    ["iGel Time", "Time to insert iGel"],
    [AMS_SETTINGS_CATEGORY, "Airway Adjunct"],
    [1, 30, 7, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowOPA),
    "LIST",
    ["Allow Guedel Tube", "Training level required to insert Guedel Tube"],
    [AMS_SETTINGS_CATEGORY, "Airway Adjunct"],
    [SETTING_SLIDER_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowSGA),
    "LIST",
    ["Allow iGel", "Training level required to insert iGel"],
    [AMS_SETTINGS_CATEGORY, "Airway Adjunct"],
    [SETTING_SLIDER_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayAdjunctReusable),
    "CHECKBOX",
    ["Airway Adjuncts Reusable", "Airway adjuncts are kept instead of discarded on removal"],
    [AMS_SETTINGS_CATEGORY, "Airway Adjunct"],
    [false],
    true
] call CBA_fnc_addSetting;

ADDON = true;
