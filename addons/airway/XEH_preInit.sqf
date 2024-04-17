#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY "ACM: Airway"

// Basic

[
    QGVAR(enable),
    "CHECKBOX",
    ["Enable Airway", "Enable airway collapse/obstruction"],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayCollapseChance),
    "SLIDER",
    "Airway Collapse Chance Multiplier",
    [ACM_SETTINGS_CATEGORY, ""],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayObstructionBloodChance),
    "SLIDER",
    "Airway Obstruction (Blood) Chance Multiplier",
    [ACM_SETTINGS_CATEGORY, ""],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayObstructionVomitChance),
    "SLIDER",
    "Airway Obstruction (Vomit) Chance Multiplier",
    [ACM_SETTINGS_CATEGORY, ""],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

// Airway Management

[
    QGVAR(treatmentTimeRecoveryPosition),
    "SLIDER",
    ["Establish Recovery Position Time", "Time to establish Recovery Position"],
    [ACM_SETTINGS_CATEGORY, "Airway Management"],
    [1, 30, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowSuctionBag),
    "LIST",
    ["Allow Suction Bag", "Training level required to use Suction Bag"],
    [ACM_SETTINGS_CATEGORY, "Airway Management"],
    [SETTING_SLIDER_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowACCUVAC),
    "LIST",
    ["Allow ACCUVAC", "Training level required to use ACCUVAC"],
    [ACM_SETTINGS_CATEGORY, "Airway Management"],
    [SETTING_SLIDER_SKILL, 1],
    true
] call CBA_fnc_addSetting;

// Airway Adjunct

[
    QGVAR(treatmentTimeOPA),
    "SLIDER",
    ["Guedel Tube Time", "Time to insert Guedel Tube"],
    [ACM_SETTINGS_CATEGORY, "Airway Adjunct"],
    [1, 30, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeSGA),
    "SLIDER",
    ["iGel Time", "Time to insert iGel"],
    [ACM_SETTINGS_CATEGORY, "Airway Adjunct"],
    [1, 30, 7, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowOPA),
    "LIST",
    ["Allow Guedel Tube", "Training level required to insert Guedel Tube"],
    [ACM_SETTINGS_CATEGORY, "Airway Adjunct"],
    [SETTING_SLIDER_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowSGA),
    "LIST",
    ["Allow iGel", "Training level required to insert iGel"],
    [ACM_SETTINGS_CATEGORY, "Airway Adjunct"],
    [SETTING_SLIDER_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(airwayAdjunctReusable),
    "CHECKBOX",
    ["Airway Adjuncts Reusable", "Airway adjuncts are kept instead of discarded on removal"],
    [ACM_SETTINGS_CATEGORY, "Airway Adjunct"],
    [false],
    true
] call CBA_fnc_addSetting;

ADDON = true;
