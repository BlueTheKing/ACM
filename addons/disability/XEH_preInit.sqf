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

ADDON = true;
