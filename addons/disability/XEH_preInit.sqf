#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#define ACM_SETTINGS_CATEGORY LLSTRING(Category)

[
    QGVAR(tourniquetImpactLimbs),
    "CHECKBOX",
    [LLSTRING(SETTING_TourniquetImpactLimbs), LLSTRING(SETTING_TourniquetImpactLimbs_Desc)],
    [ACM_SETTINGS_CATEGORY, ""],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(enableFractureSeverity),
    "CHECKBOX",
    [LLSTRING(SETTING_EnableFractureSeverity), LLSTRING(SETTING_EnableFractureSeverity_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_FractureManagement)],
    [true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowInspectForFracture),
    "LIST",
    [LLSTRING(SETTING_Allow_InspectForFracture), LLSTRING(SETTING_Allow_InspectForFracture_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_FractureManagement)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowFractureRealignment),
    "LIST",
    [LLSTRING(SETTING_Allow_FractureRealignment), LLSTRING(SETTING_Allow_FractureRealignment_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_FractureManagement)],
    [SETTING_DROPDOWN_SKILL, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(Hardcore_ComplexFracture),
    "CHECKBOX",
    [LLSTRING(SETTING_Hardcore_ComplexFracture), LLSTRING(SETTING_Hardcore_ComplexFracture_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_FractureManagement)],
    [false],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeSAMSplint),
    "SLIDER",
    [LLSTRING(SETTING_TreatmentTime_SAMSplint), LLSTRING(SETTING_TreatmentTime_SAMSplint_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_FractureManagement)],
    [1, 30, 3, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(treatmentTimeWrapSplint),
    "SLIDER",
    [LLSTRING(SETTING_TreatmentTime_WrapSplint), LLSTRING(SETTING_TreatmentTime_WrapSplint_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_FractureManagement)],
    [1, 30, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(splintFallOffTime),
    "SLIDER",
    [LLSTRING(SETTING_SplintFallOffTime), LLSTRING(SETTING_SplintFallOffTime_Desc)],
    [ACM_SETTINGS_CATEGORY, LLSTRING(Category_FractureManagement)],
    [1, 300, 60, 1],
    true
] call CBA_fnc_addSetting;

ADDON = true;
