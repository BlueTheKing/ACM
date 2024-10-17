#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY LLSTRING(Category)

//ACEGVAR(medical,STATE_MACHINE) = (configFile >> "ACM_StateMachine") call CBA_statemachine_fnc_createFromConfig;

// Items

[
    QGVAR(treatmentTimeTakeOffTourniquet),
    "SLIDER",
    [LLSTRING(SETTING_TreatmentTime_TakeOffTourniquet), LLSTRING(SETTING_TreatmentTime_TakeOffTourniquet_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Items)],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;

/*[
    QGVAR(treatmentTimeWrap),
    "SLIDER",
    [LELSTRING(damage,SETTING_TreatmentTime_WrapBodyPart), LELSTRING(damage,SETTING_TreatmentTime_WrapBodyPart_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Items)],
    [1, 30, 4, 1],
    true
] call CBA_fnc_addSetting;*/

[
    QGVAR(allowWrap),
    "LIST",
    [LELSTRING(damage,SETTING_Allow_Wrap), LELSTRING(damage,SETTING_Allow_Wrap_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Items)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeWrappedStitch),
    "SLIDER",
    [LELSTRING(damage,SETTING_TreatmentTime_WrappedStitch), LELSTRING(damage,SETTING_TreatmentTime_WrappedStitch_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Items)],
    [1, 30, 2, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeSutureStitch),
    "SLIDER",
    [LELSTRING(damage,SETTING_TreatmentTime_SutureStitch), LELSTRING(damage,SETTING_TreatmentTime_SutureStitch_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Items)],
    [0.1, 1, 0.5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeSAMSplint),
    "SLIDER",
    [LELSTRING(disability,SETTING_TreatmentTime_SAMSplint), LELSTRING(disability,SETTING_TreatmentTime_SAMSplint_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Items)],
    [1, 30, 3, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeWrapSplint),
    "SLIDER",
    [LELSTRING(disability,SETTING_TreatmentTime_WrapSplint), LELSTRING(disability,SETTING_TreatmentTime_WrapSplint_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Items)],
    [1, 30, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(splintFallOffTime),
    "SLIDER",
    [LELSTRING(disability,SETTING_SplintFallOffTime), LELSTRING(disability,SETTING_SplintFallOffTime_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Items)],
    [1, 300, 60, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Dogtag_ShowWeight),
    "CHECKBOX",
    [LLSTRING(SETTING_Dogtag_ShowWeight), LLSTRING(SETTING_Dogtag_ShowWeight_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(ignoreIncompatibleAddonWarning),
    "CHECKBOX",
    [LLSTRING(SETTING_IgnoreIncompatibleAddonWarnings), LLSTRING(SETTING_IgnoreIncompatibleAddonWarnings_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [false],
    true
] call CBA_fnc_addSetting;

// OVERRIDE ACE

[
    QACEGVAR(medical_treatment,advancedBandages),
    "LIST",
    [ACELSTRING(medical_treatment,AdvancedBandages_DisplayName), ACELSTRING(medical_treatment,AdvancedBandages_Description)],
    [ACELSTRING(medical,Category), ACELSTRING(medical_treatment,SubCategory_Treatment)],
    [[0, 1, 2], [ACELSTRING(common,Disabled), ACELSTRING(common,Enabled), ACELSTRING(medical_treatment,AdvancedBandages_EnabledCanReopen)], 2],
    true
] call CBA_fnc_addSetting;

[
    QACEGVAR(medical_treatment,locationSurgicalKit),
    "LIST",
    [ACELSTRING(medical_treatment,LocationSurgicalKit_DisplayName), ACELSTRING(medical_treatment,LocationSurgicalKit_Description)],
    [ACELSTRING(medical,Category), ACELSTRING(medical_treatment,SubCategory_Treatment)],
    [SETTING_DROPDOWN_LOCATION, 0],
    true
] call CBA_fnc_addSetting;

GVAR(itemHash) = uiNamespace getVariable QGVAR(itemHash); // Medic AI

ADDON = true;