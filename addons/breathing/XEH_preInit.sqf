#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

call FUNC(generatePTXMap);

#define ACM_SETTINGS_CATEGORY LLSTRING(Category)

[
    QGVAR(altitudeAffectOxygen),
    "CHECKBOX",
    [LLSTRING(SETTING_AltitudeAffectOxygen), LLSTRING(SETTING_AltitudeAffectOxygen_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [false],
    true
] call CBA_fnc_addSetting;

// Pneumothorax
    
[
    QGVAR(pneumothoraxEnabled),
    "CHECKBOX",
    LLSTRING(SETTING_PneumothoraxEnabled),
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Pneumothorax)],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(chestInjuryChance),
    "SLIDER",
    [LLSTRING(SETTING_ChestInjuryChance), LLSTRING(SETTING_ChestInjuryChance_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Pneumothorax)],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(pneumothoraxDeteriorateChance),
    "SLIDER",
    [LLSTRING(SETTING_PneumothoraxDeteriorateChance), LLSTRING(SETTING_PneumothoraxDeteriorateChance_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Pneumothorax)],
    [0, 2, 1, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(hemothoraxChance),
    "SLIDER",
    [LLSTRING(SETTING_HemothoraxChance), LLSTRING(SETTING_HemothoraxChance_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Pneumothorax)],
    [0, 1, 0.2, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Hardcore_ChestInjury),
    "CHECKBOX",
    [LLSTRING(SETTING_Hardcore_ChestInjury), LLSTRING(SETTING_Hardcore_ChestInjury_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Pneumothorax)],
    [false],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Hardcore_HemothoraxBleeding),
    "CHECKBOX",
    [LLSTRING(SETTING_Hardcore_HemothoraxBleeding), LLSTRING(SETTING_Hardcore_HemothoraxBleeding_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Pneumothorax)],
    [false],
    true
] call CBA_fnc_addSetting;

// Diagnosis

[
    QGVAR(allowInspectChest),
    "LIST",
    [LLSTRING(SETTING_Allow_InspectChest), LLSTRING(SETTING_Allow_InspectChest_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Diagnosis)],
    [SETTING_DROPDOWN_SKILL, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeInspectChest),
    "SLIDER",
    [LLSTRING(SETTING_TreatmentTime_InspectChest), LLSTRING(SETTING_TreatmentTime_InspectChest_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Diagnosis)],
    [1, 30, 6, 1],
    true
] call CBA_fnc_addSetting;

// Treatment

[
    QGVAR(allowNCD),
    "LIST",
    [LLSTRING(SETTING_Allow_NCD), LLSTRING(SETTING_Allow_NCD_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Treatment)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowThoracostomy),
    "LIST",
    [LLSTRING(SETTING_Allow_Thoracostomy), LLSTRING(SETTING_Allow_Thoracostomy_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Treatment)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(locationThoracostomy),
    "LIST",
    [LLSTRING(SETTING_Location_Thoracostomy), LLSTRING(SETTING_Location_Thoracostomy_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_Treatment)],
    [SETTING_DROPDOWN_LOCATION, 0],
    true
] call CBA_fnc_addSetting;

ADDON = true;
