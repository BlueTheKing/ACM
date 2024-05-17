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