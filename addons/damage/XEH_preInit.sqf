#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY "ACM: Damage"

ADDON = true;

[
    QGVAR(enable),
    "CHECKBOX",
    ["Enable Damage Addon", "Enable modified damage thresholds"],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headTraumaDeathThreshold),
    "SLIDER",
    ["Head Trauma Death Threshold", "Sets threshold for instant death from trauma to the head"],
    [ACM_SETTINGS_CATEGORY, "Thresholds"],
    [0, 40, 19, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(bodyTraumaDeathThreshold),
    "SLIDER",
    ["Torso Trauma Death Threshold", "Sets threshold for instant death from trauma to the torso"],
    [ACM_SETTINGS_CATEGORY, "Thresholds"],
    [0, 40, 24, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headTraumaCardiacArrestThreshold),
    "SLIDER",
    ["Head Trauma Cardiac Arrest Threshold", "Sets threshold for possibility of cardiac arrest from trauma to the head, using percentage of Head Trauma Death Threshold"],
    [ACM_SETTINGS_CATEGORY, "Thresholds"],
    [0, 1, 0.65, 1, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(bodyTraumaCardiacArrestThreshold),
    "SLIDER",
    ["Torso Trauma Cardiac Arrest Threshold", "Sets threshold for possibility of cardiac arrest from trauma to the torso, using percentage of Body Trauma Death Threshold"],
    [ACM_SETTINGS_CATEGORY, "Thresholds"],
    [0, 1, 0.65, 1, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(internalBleedingChanceMultiplier),
    "SLIDER",
    ["Internal Bleeding Chance Multiplier", "Chance for internal bleeding"],
    [ACM_SETTINGS_CATEGORY, "Internal Bleeding"],
    [0.1, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

/*[
    QGVAR(Hardcore_InternalBleeding),
    "CHECKBOX",
    ["[HARDCORE] Internal Bleeding", "[HARDCORE] Sets whether internal bleeding should require further treatment to fully stop"],
    [ACM_SETTINGS_CATEGORY, "Internal Bleeding"],
    [false],
    true
] call CBA_fnc_addSetting;*/

[
    QGVAR(traumaModifierAI),
    "SLIDER",
    ["AI Trauma Modifier", "Sets AI toughness compared to player thresholds"],
    [ACM_SETTINGS_CATEGORY, "AI Units"],
    [0.1, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(AIStayDownChance),
    "SLIDER",
    ["AI Stay Down Chance", "Sets chance for AI to stay down once unconscious (without intervention)"],
    [ACM_SETTINGS_CATEGORY, "AI Units"],
    [0, 1, 1, 0, true],
    true
] call CBA_fnc_addSetting;