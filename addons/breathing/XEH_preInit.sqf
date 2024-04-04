#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

call FUNC(generatePTXMap);

#define AMS_SETTINGS_CATEGORY "AMS: Breathing"

// Pneumothorax
    
[
    QGVAR(pneumothoraxEnabled),
    "CHECKBOX",
    "Pneumothorax Enabled",
    [AMS_SETTINGS_CATEGORY, "Pneumothorax"],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(chestInjuryChance),
    "SLIDER",
    ["Chest Injury Severity Multiplier", "Chance that chest injury causes pneumothorax"],
    [AMS_SETTINGS_CATEGORY, "Pneumothorax"],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(pneumothoraxDeteriorateChance),
    "SLIDER",
    ["Pneumothorax Deterioration Multiplier", "Chance that pneumothorax will deteriorate"],
    [AMS_SETTINGS_CATEGORY, "Pneumothorax"],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

// Diagnosis

[
    QGVAR(allowInspectChest),
    "LIST",
    ["Allow Inspect Chest", "Training level required to Inspect Chest"],
    [AMS_SETTINGS_CATEGORY, "Diagnosis"],
    [SETTING_SLIDER_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeInspectChest),
    "SLIDER",
    "Inspect Chest Time",
    [AMS_SETTINGS_CATEGORY, "Diagnosis"],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;

// Items

[
    QGVAR(allowNCD),
    "LIST",
    ["Allow NCD Kit", "Training level required to use NCD Kit"],
    [AMS_SETTINGS_CATEGORY, "Items"],
    [SETTING_SLIDER_SKILL, 1],
    true
] call CBA_fnc_addSetting;

ADDON = true;
