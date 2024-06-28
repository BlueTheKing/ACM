#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

call FUNC(generatePTXMap);

#define ACM_SETTINGS_CATEGORY "ACM: Breathing"

[
    QGVAR(altitudeAffectOxygen),
    "CHECKBOX",
    ["Altitude Affect Oxygen", "Sets whether oxygen saturation calculations are affected by altitude of terrain"],
    [ACM_SETTINGS_CATEGORY, ""],
    [false],
    true
] call CBA_fnc_addSetting;

// Pneumothorax
    
[
    QGVAR(pneumothoraxEnabled),
    "CHECKBOX",
    "Pneumothorax Enabled",
    [ACM_SETTINGS_CATEGORY, "Pneumothorax"],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(chestInjuryChance),
    "SLIDER",
    ["Chest Injury Severity Multiplier", "Chance that a chest injury causes pneumothorax"],
    [ACM_SETTINGS_CATEGORY, "Pneumothorax"],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(pneumothoraxDeteriorateChance),
    "SLIDER",
    ["Pneumothorax Deterioration Multiplier", "Chance that pneumothorax will deteriorate"],
    [ACM_SETTINGS_CATEGORY, "Pneumothorax"],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Hardcore_ChestInjury),
    "CHECKBOX",
    ["[HARDCORE] Chest Injuries", "[HARDCORE] Sets whether Tension Pneumothorax should require further treatment to fully heal"],
    [ACM_SETTINGS_CATEGORY, "Pneumothorax"],
    [false],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Hardcore_HemothoraxBleeding),
    "CHECKBOX",
    ["[HARDCORE] Hemothorax Bleeding", "[HARDCORE] Sets whether Hemothorax should require further treatment to fully stop internal bleeding"],
    [ACM_SETTINGS_CATEGORY, "Pneumothorax"],
    [false],
    true
] call CBA_fnc_addSetting;

// Diagnosis

[
    QGVAR(allowInspectChest),
    "LIST",
    ["Allow Inspect Chest", "Training level required to Inspect Chest"],
    [ACM_SETTINGS_CATEGORY, "Diagnosis"],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeInspectChest),
    "SLIDER",
    "Inspect Chest Time",
    [ACM_SETTINGS_CATEGORY, "Diagnosis"],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;

// Treatment

[
    QGVAR(allowNCD),
    "LIST",
    ["Allow NCD Kit", "Training level required to use NCD Kit"],
    [ACM_SETTINGS_CATEGORY, "Treatment"],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowThoracostomy),
    "LIST",
    ["Allow Thoracostomy", "Training level required to perform Thoracostomy"],
    [ACM_SETTINGS_CATEGORY, "Treatment"],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(locationThoracostomy),
    "LIST",
    ["Locations Thoracostomy", "Sets locations at which Thoracostomy can be performed"],
    [ACM_SETTINGS_CATEGORY, "Treatment"],
    [SETTING_DROPDOWN_LOCATION, 3],
    true
] call CBA_fnc_addSetting;

ADDON = true;
