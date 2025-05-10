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
    [true],
    true,
    {},
    true
] call CBA_fnc_addSetting;

// PPE List

[
    QGVAR(customPPEList_gasmask),
    "EDITBOX",
    [LLSTRING(SETTING_CustomPPEList_GasMask), LLSTRING(SETTING_CustomPPEList_GasMask_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    "",
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(customPPEList_suit),
    "EDITBOX",
    [LLSTRING(SETTING_CustomPPEList_Suit), LLSTRING(SETTING_CustomPPEList_Suit_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    "",
    true,
    {},
    true
] call CBA_fnc_addSetting;

// Vehicle List

[
    QGVAR(customVehicleList_CBRN),
    "EDITBOX",
    [LLSTRING(SETTING_CustomVehicleList_CBRN), LLSTRING(SETTING_CustomVehicleList_CBRN_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    "",
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(customVehicleList_sealed),
    "EDITBOX",
    [LLSTRING(SETTING_CustomVehicleList_Sealed), LLSTRING(SETTING_CustomVehicleList_Sealed_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    "",
    true,
    {},
    true
] call CBA_fnc_addSetting;

// Autoinjectors

[
    QGVAR(allowATNAAutoinjector),
    "LIST",
    [LLSTRING(SETTING_Allow_ATNAAutoinjector), LLSTRING(SETTING_Allow_ATNAAutoinjector_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Autoinjectors)],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowMidazolamAutoinjector),
    "LIST",
    [LLSTRING(SETTING_Allow_MidazolamAutoinjector), LLSTRING(SETTING_Allow_MidazolamAutoinjector_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Autoinjectors)],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

// Chemical General

[
    QGVAR(chemicalAffectAI),
    "CHECKBOX",
    [LLSTRING(SETTING_ChemicalAffectAI), LLSTRING(SETTING_ChemicalAffectAI_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical)],
    [true],
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(chemicalAffectAISkill),
    "CHECKBOX",
    [LLSTRING(SETTING_ChemicalAffectAISkill), LLSTRING(SETTING_ChemicalAffectAISkill_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical)],
    [true],
    true,
    {},
    true
] call CBA_fnc_addSetting;

// CS Gas

[
    QGVAR(CSCauseBlindness),
    "CHECKBOX",
    [LLSTRING(SETTING_CSCauseBlindness), LLSTRING(SETTING_CSCauseBlindness_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_CS)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

// Chlorine Gas

[
    QGVAR(chlorineCauseBlindness),
    "CHECKBOX",
    [LLSTRING(SETTING_ChlorineCauseBlindness), LLSTRING(SETTING_ChlorineCauseBlindness_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_Chlorine)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

// Sarin Gas

[
    QGVAR(sarinIsColorless),
    "CHECKBOX",
    [LLSTRING(SETTING_SarinIsColorless), LLSTRING(SETTING_SarinIsColorless_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_Sarin)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

// Lewisite

[
    QGVAR(lewisiteCauseBlindness),
    "CHECKBOX",
    [LLSTRING(SETTING_LewisiteCauseBlindness), LLSTRING(SETTING_LewisiteCauseBlindness_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_Lewisite)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(lewisiteIsColorless),
    "CHECKBOX",
    [LLSTRING(SETTING_LewisiteIsColorless), LLSTRING(SETTING_LewisiteIsColorless_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Chemical_Lewisite)],
    [false],
    true,
    {},
    true
] call CBA_fnc_addSetting;

ADDON = true;