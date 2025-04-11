#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY LLSTRING(Category)

ADDON = true;

[
    QGVAR(enable),
    "CHECKBOX",
    [LLSTRING(SETTING_Enable), LLSTRING(SETTING_Enable_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headTraumaDeathThreshold),
    "SLIDER",
    [LLSTRING(SETTING_HeadTraumaDeathThreshold), LLSTRING(SETTING_HeadTraumaDeathThreshold_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Thresholds)],
    [0, 40, 19, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(bodyTraumaDeathThreshold),
    "SLIDER",
    [LLSTRING(SETTING_BodyTraumaDeathThreshold), LLSTRING(SETTING_BodyTraumaDeathThreshold_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Thresholds)],
    [0, 40, 24, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headTraumaCardiacArrestThreshold),
    "SLIDER",
    [LLSTRING(SETTING_HeadTraumaCardiacArrestThreshold), LLSTRING(SETTING_HeadTraumaCardiacArrestThreshold_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Thresholds)],
    [0, 40, 12, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(bodyTraumaCardiacArrestThreshold),
    "SLIDER",
    [LLSTRING(SETTING_BodyTraumaCardiacArrestThreshold), LLSTRING(SETTING_BodyTraumaCardiacArrestThreshold_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Thresholds)],
    [0, 40, 20, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(internalBleedingChanceMultiplier),
    "SLIDER",
    [LLSTRING(SETTING_InternalBleedingChanceMultiplier), LLSTRING(SETTING_InternalBleedingChanceMultiplier_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_InternalBleeding)],
    [0.1, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

/*[
    QGVAR(Hardcore_InternalBleeding),
    "CHECKBOX",
    [LLSTRING(SETTING_Hardcore_InternalBleeding), LLSTRING(SETTING_Hardcore_InternalBleeding_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_InternalBleeding)],
    [false],
    true
] call CBA_fnc_addSetting;*/

[
    QGVAR(headTraumaDeathThresholdAI),
    "SLIDER",
    [LLSTRING(SETTING_HeadTraumaDeathThresholdAI), LLSTRING(SETTING_HeadTraumaDeathThresholdAI_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AIUnits)],
    [0, 40, 19, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(bodyTraumaDeathThresholdAI),
    "SLIDER",
    [LLSTRING(SETTING_BodyTraumaDeathThresholdAI), LLSTRING(SETTING_BodyTraumaDeathThresholdAI_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AIUnits)],
    [0, 40, 24, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headTraumaCardiacArrestThresholdAI),
    "SLIDER",
    [LLSTRING(SETTING_HeadTraumaCardiacArrestThresholdAI), LLSTRING(SETTING_HeadTraumaCardiacArrestThresholdAI_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AIUnits)],
    [0, 40, 12, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(bodyTraumaCardiacArrestThresholdAI),
    "SLIDER",
    [LLSTRING(SETTING_BodyTraumaCardiacArrestThresholdAI), LLSTRING(SETTING_BodyTraumaCardiacArrestThresholdAI_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AIUnits)],
    [0, 40, 20, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(AIStayDownChance),
    "SLIDER",
    [LLSTRING(SETTING_AIStayDownChance), LLSTRING(SETTING_AIStayDownChance_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_AIUnits)],
    [0, 1, 1, 0, true],
    true
] call CBA_fnc_addSetting;